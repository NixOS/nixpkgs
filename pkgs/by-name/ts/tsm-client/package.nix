{ lib
, callPackage
, nixosTests
, stdenv
, fetchurl
, autoPatchelfHook
, rpmextract
, libxcrypt-legacy
, zlib
, lvm2  # LVM image backup and restore functions (optional)
, acl  # EXT2/EXT3/XFS ACL support (optional)
, gnugrep
, procps
, jdk8  # Java GUI (needed for `enableGui`)
, buildEnv
, makeWrapper
, enableGui ? false  # enables Java GUI `dsmj`
# path to `dsm.sys` configuration files
, dsmSysCli ? "/etc/tsm-client/cli.dsm.sys"
, dsmSysApi ? "/etc/tsm-client/api.dsm.sys"
}:


# For an explanation of optional packages
# (features provided by them, version limits), see
# https://www.ibm.com/support/pages/node/660813#Version%208.1


# IBM Tivoli Storage Manager Client uses a system-wide
# client system-options file `dsm.sys` and expects it
# to be located in a directory within the package.
# Note that the command line client and the API use
# different "dms.sys" files (located in different directories).
# Since these files contain settings to be altered by the
# admin user (e.g. TSM server name), we create symlinks
# in place of the files that the client attempts to open.
# Use the arguments `dsmSysCli` and `dsmSysApi` to
# provide the location of the configuration files for
# the command-line interface and the API, respectively.
#
# While the command-line interface contains wrappers
# that help the executables find the configuration file,
# packages that link against the API have to
# set the environment variable `DSMI_DIR` to
# point to this derivations `/dsmi_dir` directory symlink.
# Other environment variables might be necessary,
# depending on local configuration or usage; see:
# https://www.ibm.com/docs/en/storage-protect/8.1.22?topic=solaris-set-api-environment-variables


# The newest version of TSM client should be discoverable by
# going to the `downloadPage` (see `meta` below).
# Find the "Backup-archive client" table on that page.
# Look for "Download Documents" of the latest release.
# Follow the "Download Information" link.
# Look for the "Linux x86_64 ..." rows in the table at
# the bottom of the page and follow their "HTTPS" links (one
# link per row -- each link might point to the latest release).
# In the directory listings to show up,
# check the big `.tar` file.
#
# (as of 2023-07-01)


let

  meta = {
    homepage = "https://www.ibm.com/products/storage-protect";
    downloadPage = "https://www.ibm.com/support/pages/ibm-storage-protect-downloads-latest-fix-packs-and-interim-fixes";
    platforms = [ "x86_64-linux" ];
    mainProgram = "dsmc";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    maintainers = [ lib.maintainers.yarny ];
    description = "IBM Storage Protect (Tivoli Storage Manager) CLI and API";
    longDescription = ''
      IBM Storage Protect (Tivoli Storage Manager) provides
      a single point of control for backup and recovery.
      This package contains the client software, that is,
      a command line client and linkable libraries.

      Note that the software requires a system-wide
      client system-options file (commonly named "dsm.sys").
      This package allows to use separate files for
      the command-line interface and for the linkable API.
      The location of those files can
      be provided as build parameters.
    '';
  };

  passthru.tests = {
    test-cli = callPackage ./test-cli.nix {};
    test-gui = nixosTests.tsm-client-gui;
  };

  mkSrcUrl = version:
    let
      major = lib.versions.major version;
      minor = lib.versions.minor version;
      patch = lib.versions.patch version;
      fixup = lib.lists.elemAt (lib.versions.splitVersion version) 3;
    in
      "https://public.dhe.ibm.com/storage/tivoli-storage-management/${if fixup=="0" then "maintenance" else "patches"}/client/v${major}r${minor}/Linux/LinuxX86/BA/v${major}${minor}${patch}/${version}-TIV-TSMBAC-LinuxX86.tar";

  unwrapped = stdenv.mkDerivation rec {
    name = "tsm-client-${version}-unwrapped";
    version = "8.1.22.0";
    src = fetchurl {
      url = mkSrcUrl version;
      hash = "sha512-tsmrnZ0zoGCmpp9ey2K6ad8tMVBgB+lYMTx7YgVOSXNeiGT76fUYdr9DmO+PEsj+J/Pg/skd7ywqsBbjQT+eiw==";
    };
    inherit meta passthru;

    nativeBuildInputs = [
      autoPatchelfHook
      rpmextract
    ];
    buildInputs = [
      libxcrypt-legacy
      stdenv.cc.cc
      zlib
    ];
    runtimeDependencies = [
      (lib.attrsets.getLib lvm2)
    ];
    sourceRoot = ".";

    postUnpack = ''
      rpmextract TIVsm-API64.x86_64.rpm
      rpmextract TIVsm-APIcit.x86_64.rpm
      rpmextract TIVsm-BA.x86_64.rpm
      rpmextract TIVsm-BAcit.x86_64.rpm
      rpmextract TIVsm-BAhdw.x86_64.rpm
      rpmextract TIVsm-JBB.x86_64.rpm
      # use globbing so that version updates don't break the build:
      rpmextract gskcrypt64-*.linux.x86_64.rpm
      rpmextract gskssl64-*.linux.x86_64.rpm
    '';

    installPhase = ''
      runHook preInstall
      mkdir --parents $out
      mv --target-directory=$out usr/* opt
      runHook postInstall
    '';

    # fix relative symlinks after `/usr` was moved up one level,
    # fix absolute symlinks pointing to `/opt`
    preFixup = ''
      for link in $out/lib{,64}/* $out/bin/*
      do
        target=$(readlink "$link")
        if [ "$(cut -b -6 <<< "$target")" != "../../" ]
        then
          echo "cannot fix this symlink: $link -> $target"
          exit 1
        fi
        ln --symbolic --force --no-target-directory "$out/$(cut -b 7- <<< "$target")" "$link"
      done
      for link in $(find $out -type l -lname '/opt/*')
      do
        ln --symbolic --force --no-target-directory "$out$(readlink "$link")" "$link"
      done
    '';
  };

  binPath = lib.makeBinPath ([ acl gnugrep procps ]
    ++ lib.optional enableGui jdk8);

in

buildEnv {
  name = "tsm-client-${unwrapped.version}";
  meta = meta // lib.attrsets.optionalAttrs enableGui {
    mainProgram = "dsmj";
  };
  passthru = passthru // { inherit unwrapped; };
  paths = [ unwrapped ];
  nativeBuildInputs = [ makeWrapper ];
  pathsToLink = [
    "/"
    "/bin"
    "/opt/tivoli/tsm/client/ba/bin"
    "/opt/tivoli/tsm/client/api/bin64"
  ];
  # * Provide top-level symlinks `dsm_dir` and `dsmi_dir`
  #   to the so-called "installation directories"
  # * Add symlinks to the "installation directories"
  #   that point to the `dsm.sys` configuration files
  # * Drop the Java GUI executable unless `enableGui` is set
  # * Create wrappers for the command-line interface to
  #   prepare `PATH` and `DSM_DIR` environment variables
  postBuild = ''
    ln --symbolic --no-target-directory opt/tivoli/tsm/client/ba/bin $out/dsm_dir
    ln --symbolic --no-target-directory opt/tivoli/tsm/client/api/bin64 $out/dsmi_dir
    ln --symbolic --no-target-directory "${dsmSysCli}" $out/dsm_dir/dsm.sys
    ln --symbolic --no-target-directory "${dsmSysApi}" $out/dsmi_dir/dsm.sys
    ${lib.optionalString (!enableGui) "rm $out/bin/dsmj"}
    for bin in $out/bin/*
    do
      target=$(readlink "$bin")
      rm "$bin"
      makeWrapper "$target" "$bin" \
        --prefix PATH : "$out/dsm_dir:${binPath}" \
        --set DSM_DIR $out/dsm_dir
    done
  '';
}

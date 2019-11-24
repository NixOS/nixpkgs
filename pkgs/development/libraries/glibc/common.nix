/* Build configuration used to build glibc, Info files, and locale
   information.

   Note that this derivation has multiple outputs and does not respect the
   standard convention of putting the executables into the first output. The
   first output is `lib` so that the libraries provided by this derivation
   can be accessed directly, e.g.

     "${pkgs.glibc}/lib/ld-linux-x86_64.so.2"

   The executables are put into `bin` output and need to be referenced via
   the `bin` attribute of the main package, e.g.

     "${pkgs.glibc.bin}/bin/ldd".

  The executables provided by glibc typically include `ldd`, `locale`, `iconv`
  but the exact set depends on the library version and the configuration.
*/

{ stdenv, lib
, buildPackages
, fetchurl, fetchpatch
, linuxHeaders ? null
, gd ? null, libpng ? null
, bison
}:

{ name
, withLinuxHeaders ? false
, profilingLibraries ? false
, withGd ? false
, meta
, ...
} @ args:

let
  version = "2.27";
  patchSuffix = "";
  sha256 = "0wpwq7gsm7sd6ysidv0z575ckqdg13cr2njyfgrbgh4f65adwwji";
in

assert withLinuxHeaders -> linuxHeaders != null;
assert withGd -> gd != null && libpng != null;

stdenv.mkDerivation ({
  inherit version;
  linuxHeaders = if withLinuxHeaders then linuxHeaders else null;

  inherit (stdenv) is64bit;

  enableParallelBuilding = true;

  patches =
    [
      /* Have rpcgen(1) look for cpp(1) in $PATH.  */
      ./rpcgen-path.patch

      /* Allow NixOS and Nix to handle the locale-archive. */
      ./nix-locale-archive.patch

      /* Don't use /etc/ld.so.cache, for non-NixOS systems.  */
      ./dont-use-system-ld-so-cache.patch

      /* Don't use /etc/ld.so.preload, but /etc/ld-nix.so.preload.  */
      ./dont-use-system-ld-so-preload.patch

      /* The command "getconf CS_PATH" returns the default search path
         "/bin:/usr/bin", which is inappropriate on NixOS machines. This
         patch extends the search path by "/run/current-system/sw/bin". */
      ./fix_path_attribute_in_getconf.patch

      /* Allow running with RHEL 6 -like kernels.  The patch adds an exception
        for glibc to accept 2.6.32 and to tag the ELFs as 2.6.32-compatible
        (otherwise the loader would refuse libc).
        Note that glibc will fully work only on their heavily patched kernels
        and we lose early mismatch detection on 2.6.32.

        On major glibc updates we should check that the patched kernel supports
        all the required features.  ATM it's verified up to glibc-2.26-131.
        # HOWTO: check glibc sources for changes in kernel requirements
        git log -p glibc-2.25.. sysdeps/unix/sysv/linux/x86_64/kernel-features.h sysdeps/unix/sysv/linux/kernel-features.h
        # get kernel sources (update the URL)
        mkdir tmp && cd tmp
        curl http://vault.centos.org/6.9/os/Source/SPackages/kernel-2.6.32-696.el6.src.rpm | rpm2cpio - | cpio -idmv
        tar xf linux-*.bz2
        # check syscall presence, for example
        less linux-*?/arch/x86/kernel/syscall_table_32.S
       */
      ./allow-kernel-2.6.32.patch
      /* Provide utf-8 locales by default, so we can use it in stdenv without depending on our large locale-archive. */
      (fetchurl {
        url = "https://salsa.debian.org/glibc-team/glibc/raw/49767c9f7de4828220b691b29de0baf60d8a54ec/debian/patches/localedata/locale-C.diff";
        sha256 = "0irj60hs2i91ilwg5w7sqrxb695c93xg0ik7yhhq9irprd7fidn4";
      })

      # https://sourceware.org/git/gitweb.cgi?p=glibc.git;h=5460617d1567657621107d895ee2dd83bc1f88f2
      ./CVE-2018-11236.patch
      # https://sourceware.org/git/gitweb.cgi?p=glibc.git;h=f51c8367685dc888a02f7304c729ed5277904aff
      ./CVE-2018-11237.patch
    ]
    ++ lib.optionals stdenv.isx86_64 [
      ./fix-x64-abi.patch
      ./2.27-CVE-2019-19126.patch
    ]
    ++ lib.optional stdenv.hostPlatform.isMusl ./fix-rpc-types-musl-conflicts.patch
    ++ lib.optional stdenv.buildPlatform.isDarwin ./darwin-cross-build.patch

    # Remove after upgrading to glibc 2.28+
    ++ lib.optional (stdenv.hostPlatform != stdenv.buildPlatform) (fetchpatch {
      url = "https://sourceware.org/git/?p=glibc.git;a=patch;h=780684eb04298977bc411ebca1eadeeba4877833";
      name = "correct-pwent-parsing-issue-and-resulting-build.patch";
      sha256 = "08fja894vzaj8phwfhsfik6jj2pbji7kypy3q8pgxvsd508zdv1q";
      excludes = [ "ChangeLog" ];
    });

  postPatch =
    ''
      # Needed for glibc to build with the gnumake 3.82
      # http://comments.gmane.org/gmane.linux.lfs.support/31227
      sed -i 's/ot \$/ot:\n\ttouch $@\n$/' manual/Makefile

      # nscd needs libgcc, and we don't want it dynamically linked
      # because we don't want it to depend on bootstrap-tools libs.
      echo "LDFLAGS-nscd += -static-libgcc" >> nscd/Makefile
    '';

  configureFlags =
    [ "-C"
      "--enable-add-ons"
      "--enable-obsolete-nsl"
      "--enable-obsolete-rpc"
      "--sysconfdir=/etc"
      "--enable-stackguard-randomization"
      (lib.withFeatureAs withLinuxHeaders "headers" "${linuxHeaders}/include")
      (lib.enableFeature profilingLibraries "profile")
    ] ++ lib.optionals withLinuxHeaders [
      "--enable-kernel=3.2.0" # can't get below with glibc >= 2.26
    ] ++ lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
      (lib.flip lib.withFeature "fp"
         (stdenv.hostPlatform.platform.gcc.float or (stdenv.hostPlatform.parsed.abi.float or "hard") == "soft"))
      "--with-__thread"
    ] ++ lib.optionals (stdenv.hostPlatform == stdenv.buildPlatform && stdenv.hostPlatform.isAarch32) [
      "--host=arm-linux-gnueabi"
      "--build=arm-linux-gnueabi"

      # To avoid linking with -lgcc_s (dynamic link)
      # so the glibc does not depend on its compiler store path
      "libc_cv_as_needed=no"
    ] ++ lib.optional withGd "--with-gd";

  installFlags = [ "sysconfdir=$(out)/etc" ];

  outputs = [ "out" "bin" "dev" "static" ];

  depsBuildBuild = [ buildPackages.stdenv.cc ];
  nativeBuildInputs = [ bison ];
  buildInputs = [ linuxHeaders ] ++ lib.optionals withGd [ gd libpng ];

  # Needed to install share/zoneinfo/zone.tab.  Set to impure /bin/sh to
  # prevent a retained dependency on the bootstrap tools in the stdenv-linux
  # bootstrap.
  BASH_SHELL = "/bin/sh";

  passthru = { inherit version; };
}

// (removeAttrs args [ "withLinuxHeaders" "withGd" ]) //

{
  name = name + "-${version}${patchSuffix}";

  src = fetchurl {
    url = "mirror://gnu/glibc/glibc-${version}.tar.xz";
    inherit sha256;
  };

  # Remove absolute paths from `configure' & co.; build out-of-tree.
  preConfigure = ''
    export PWD_P=$(type -tP pwd)
    for i in configure io/ftwtest-sh; do
        # Can't use substituteInPlace here because replace hasn't been
        # built yet in the bootstrap.
        sed -i "$i" -e "s^/bin/pwd^$PWD_P^g"
    done

    mkdir ../build
    cd ../build

    configureScript="`pwd`/../$sourceRoot/configure"

    ${lib.optionalString (stdenv.cc.libc != null)
      ''makeFlags="$makeFlags BUILD_LDFLAGS=-Wl,-rpath,${stdenv.cc.libc}/lib"''
    }


  '' + lib.optionalString (stdenv.hostPlatform != stdenv.buildPlatform) ''
    sed -i s/-lgcc_eh//g "../$sourceRoot/Makeconfig"

    cat > config.cache << "EOF"
    libc_cv_forced_unwind=yes
    libc_cv_c_cleanup=yes
    libc_cv_gnu89_inline=yes
    EOF
  '';

  preBuild = lib.optionalString withGd "unset NIX_DONT_SET_RPATH";

  doCheck = false; # fails

  meta = {
    homepage = https://www.gnu.org/software/libc/;
    description = "The GNU C Library";

    longDescription =
      '' Any Unix-like operating system needs a C library: the library which
         defines the "system calls" and other basic facilities such as
         open, malloc, printf, exit...

         The GNU C library is used as the C library in the GNU system and
         most systems with the Linux kernel.
      '';

    license = lib.licenses.lgpl2Plus;

    maintainers = [ lib.maintainers.eelco ];
    platforms = lib.platforms.linux;
  } // meta;
}

// lib.optionalAttrs (stdenv.hostPlatform != stdenv.buildPlatform) {
  preInstall = null; # clobber the native hook

  # To avoid a dependency on the build system 'bash'.
  preFixup = ''
    rm -f $bin/bin/{ldd,tzselect,catchsegv,xtrace}
  '';
})

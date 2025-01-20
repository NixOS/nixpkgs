{ ydbVersion, ydbCommitRef, ydbNixHash,

enableAsan ? false,

lib, config, makeWrapper, stdenv, writeText, writeScript,

cmake, coreutils-full, elfutils, fetchFromGitLab, git, glibcLocales, libxcrypt
, icu, ncurses, readline, openssl, pkg-config, tcsh, util-linux, zlib,

nixosTests }:

# To test this package, go to $NIXPKGS/nixos/tests and run:
#   $ $(nix-build -A driverInteractive yottadb.nix)/bin/nixos-test-driver -I
#   >>> test_script()
#
# Or non-interactive:
#   $ $(nix-build -A driver yottadb.nix)/bin/nixos-test-driver

stdenv.mkDerivation rec {
  pname = "yottadb";
  version = "${ydbVersion}";

  src = fetchFromGitLab {
    owner = "YottaDB";
    repo = "DB/YDB";
    rev = "${ydbCommitRef}";
    hash = "${ydbNixHash}";
  };

  env.NIX_CFLAGS_COMPILE =
    ''-DYDB_EXTERNAL_SECSHR_PARENT_DIR="${ydbSecRunDir}"'';

  enableParallelBuilding = true;

  nativeBuildInputs = [
    coreutils-full
    elfutils.dev
    glibcLocales
    libxcrypt
    icu
    openssl
    util-linux

    cmake
    git
    icu.dev
    makeWrapper
    ncurses
    readline
    pkg-config
    tcsh
    zlib
  ];

  buildInputs = [
    coreutils-full
    elfutils.dev
    glibcLocales
    libxcrypt
    icu
    openssl
    util-linux
  ];

  asanOptions = lib.concatStringsSep ":"
    (lib.mapAttrsToList (x: y: "${x}=${if y then "1" else "0"}") {
      detect_leaks = false;
      disable_coredump = false;
      unmap_shadow_on_exit = true;
      abort_on_error = true;
    });

  cmakeFlags = [
    (lib.cmakeOptionType "filepath" "YDB_INSTALL_DIR"
      "${placeholder "out"}/dist")
    (lib.cmakeBool "ENABLE_ASAN" enableAsan)
  ];

  gitWatcherMock = writeText "git-watcher-mock.cmake" ''
    add_custom_target(check_git_repository DEPENDS ''${POST_CONFIGURE_FILE})
    set(YDB_RELEASE_STAMP "19700101 00:00 ${ydbCommitRef} (nixpkgs@${lib.version})")
    configure_file("''${PRE_CONFIGURE_FILE}" "''${POST_CONFIGURE_FILE}" @ONLY)
  '';

  etcOsReleaseMock = writeText "" ''
    ID=nixos
    NAME="NixOS"
  '';

  postPatch = ''
    cp ${gitWatcherMock} cmake/git-watcher.cmake
    substituteInPlace CMakeLists.txt sr_unix/ydbinstall.sh \
      --replace "/etc/os-release" "${etcOsReleaseMock}"
  '';

  preBuild = ''
    # Make sure that we can find all the runtime libs in order to
    # use the freshly built M compiler to build the M code...
    export LD_LIBRARY_PATH="${lib.makeLibraryPath buildInputs}:$LD_LIBRARY_PATH"

    # Only applicable when built with enableAsan=true
    export ASAN_OPTIONS="${asanOptions}"
  '';

  # NOTE: Setting exec_prefix=@@YDB_EXEDIR@@, includedir=@@YDB_INCDIR@@
  # and libdir=@@YDB_LIBDIR@@ breaks dependent software (YDBRust for
  # instance) for some reason.
  yottadbPkgConfigTemplate = writeText "yottadb.pc.in" ''
    prefix=@@YDB_DIST@@

    exec_prefix=''${prefix}
    includedir=''${prefix}
    libdir=''${exec_prefix}

    Name: YottaDB
    Description: YottaDB database library
    Version: ${version}
    Cflags: -I''${includedir}
    Libs: -L''${libdir} -lyottadb -Wl,-rpath,''${libdir}
  '';

  ydbSecRunDir = "/run/${pname}/${version}";

  yottadbGde = writeScript "gde" ''
    #!/usr/bin/env bash
    # Use bin/yottadb, not dist/yottadb (see the note on yottadb-shell wrapper)
    exec @@YDB_PKG_DIR@@/bin/yottadb -r GDE "$@"
  '';

  postInstall = ''
    set -x
    # NOTE: In future, consider using a patched versions
    # of `ydbinstall` and `configure` scripts while
    # adding Nix-specific changes on top of that.

    mkdir -p $out/bin $out/lib $out/dist/utf8
    mkdir -p $out/lib/pkgconfig $out/include

    cd $out/dist

    mkdir -p $out/lib/tmpfiles.d/
    cat > $out/lib/tmpfiles.d/${pname}.conf << EOF
      # Create `gtmsrcshrdir` with the right permissions and ownership
      d  ${ydbSecRunDir}/gtmsecshrdir 0500 root root

      # Copy `gtmsecshr` binary and set the right permissions and ownership
      C+ ${ydbSecRunDir}/gtmsecshrdir/gtmsecshr - - - - $out/dist/gtmsecshr-real
      z  ${ydbSecRunDir}/gtmsecshrdir/gtmsecshr 4500 root root

      # Copy `gtmsecshr` *wrapper* binary and set the right permissions and ownership
      C+ ${ydbSecRunDir}/gtmsecshr - - - - $out/dist/gtmsecshr-wrap
      z  ${ydbSecRunDir}/gtmsecshr 4555 root root
    EOF

    mv gtmsecshr gtmsecshr-wrap
    mv gtmsecshrdir/gtmsecshr gtmsecshr-real
    rmdir gtmsecshrdir
    ln -s ${ydbSecRunDir}/gtmsecshrdir .
    ln -s ${ydbSecRunDir}/gtmsecshr .

    # Make sure we have ICU in library path (why is this needed only for ICU?)
    # NOTE: make{Binary}Wrapper can manipulate argv0, but not /proc/self/comm
    # so we will cheat a bit and have the following call structure:
    #   $out/bin/yottadb -> $out/dist/yottadb-shell -> $out/dist/yottadb
    makeWrapper "$out/dist/yottadb" "$out/dist/yottadb-shell" \
      --prefix LD_LIBRARY_PATH ":" "${lib.makeLibraryPath [ icu ]}" \
      --set-default ydb_dist $out/dist/utf8 \
      --set-default ydb_chset UTF-8 \
      --set-default ydb_icu_version $(icu-config --version) \
      --set-default LANG en_US.UTF-8 \
      --set-default LC_ALL en_US.UTF-8

    cd $out/dist
    ln -rs yottadb mumps
    substitute "${yottadbGde}" gde --replace "@@YDB_PKG_DIR@@" "$out"
    chmod a+x gde
    for utl in dse ftok gde gtcm_gnp_server gtcm_pkdisp gtcm_play gtcm_server gtcm_shmclean lke mupip semstat2 yottadb mumps ; do
      ln -rs $utl ../bin/
      ln -rs $utl ./utf8/
    done
    # The bin/yottadb will point to the yottadb-shell wrapper that
    # has most of the runtime environment vars set automatically
    # (also see the note on yottadb-shell makeWrapper)
    ln -rsf "$out/dist/yottadb-shell" $out/bin/yottadb
    ln -rsf "$out/dist/yottadb-shell" $out/bin/mumps
    ln -rs libyottadb.so ../lib/
    for inc in $(find -maxdepth 1 -mindepth 1 -name '*.h') ; do
      ln -rs $inc ../include/
      ln -rs $inc ./utf8/
    done

    ln -rs $out/dist/gtmsecshrdir $out/dist/utf8/gtmsecshrdir
    ln -rs $out/dist/gtmsecshr $out/dist/utf8/gtmsecshr

    substitute "${yottadbPkgConfigTemplate}" "$out/lib/pkgconfig/yottadb.pc" \
      --replace "@@YDB_DIST@@" "$out/dist" \
      --replace "@@YDB_EXEDIR@@" "$out/bin" \
      --replace "@@YDB_INCDIR@@" "$out/include" \
      --replace "@@YDB_LIBDIR@@" "$out/lib"

    # Embed source to OBJs, so that we can drop SRCs
    export ydb_compile="-embed_source -noignore"

    # Build M-mode dist
    export ydb_dist=$out/dist ydb_chset=M
    cd $ydb_dist
    $out/bin/yottadb -r %XCMD 'zhalt $s($zyre["r${version}":0,1:127)&$s($zch="M":0,1:126)'
    $out/bin/yottadb -r %XCMD 'zhalt $s($zrel["r${ydbCommitRef}":0,1:127)&$s($zch="M":0,1:126)'
    $out/bin/yottadb -r %XCMD 'd SILENT^%RSEL("*","SRC") s x="" f  s x=$o(%ZR(x)) q:x=""  w "["_$zch_"] Building "_x_" ...",! zl $tr(x,"%","_")'

    # Build UTF8-mode dist
    for rtn in *.m *.gld *.dat ; do
      ln -rs $rtn utf8/
    done
    unset ydb_chset ydb_icu_version ydb_dist
    cd $out/dist/utf8
    $out/bin/yottadb -r %XCMD 'zhalt $s($zyre["$r{version}":0,1:127)&$s($zch="UTF-8":0,1:126)'
    $out/bin/yottadb -r %XCMD 'zhalt $s($zrel["$r{ydbCommitRef}":0,1:127)&$s($zch="UTF-8":0,1:126)'
    $out/bin/yottadb -r %XCMD 'd SILENT^%RSEL("*","SRC") s x="" f  s x=$o(%ZR(x)) q:x=""  w "["_$zch_"] Building "_x_" ...",! zl $tr(x,"%","_")'

    # Wipe SRCs as Nix is read-only and sets both .o and .m to the same mtime, so compiler tries to compile all the time, but cannot write
    rm -f $out/dist/*.m $out/dist/utf8/*.m

    # Also generate a single libyottadbutil.so to consolidate all system routines
    libYdbUtil=libyottadbutil
    isarmYdb=$(file $ydb_dist/yottadb | grep -wc "ARM" || true)
    ldflags="-shared"
    if [ "$isarmYdb" -eq 1 ] ; then
      ldcmd="cc"  # Linux on ARM builds shared ELFs only using 'cc', not 'ld'
    else
      ldcmd="ld.gold"
    fi
    cd $out/dist
    $ldcmd $ldflags -o $libYdbUtil.so *.o
    ln -rs $libYdbUtil.so ../lib/$libYdbUtil-m.so
    cd $out/dist/utf8
    $ldcmd $ldflags -o $libYdbUtil.so *.o
    ln -rs $libYdbUtil.so ../../lib/$libYdbUtil-utf8.so

    # Default is UTF-8
    cd $out/lib
    ln -rs $libYdbUtil-utf8.so $libYdbUtil.so
  '';

  passthru.tests = nixosTests.yottadb;

  meta = with lib; {
    description = "A proven Multi-Language NoSQL database engine";
    homepage = "https://gitlab.com/YottaDB/DB/YDB";
    license = licenses.afl3;
    maintainers = [ maintainers.ztmr ];

    # NOTE: Linux on ARM should be supported, but we haven't tested it
    platforms = [ "x86_64-linux" ];
  };
}


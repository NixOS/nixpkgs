{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  autoreconfHook,
  perl,
  gdb,
  writeScript,
}:

stdenv.mkDerivation rec {
  pname = "valgrind";
  version = "3.25.1";

  src = fetchurl {
    url = "https://sourceware.org/pub/${pname}/${pname}-${version}.tar.bz2";
    hash = "sha256-Yd640HJ7RcJo79wbO2yeZ5zZfL9e5LKNHerXyLeica8=";
  };

  patches = [
    # Fix checks on Musl.
    # https://bugs.kde.org/show_bug.cgi?id=453929
    (fetchpatch {
      url = "https://bugsfiles.kde.org/attachment.cgi?id=148912";
      sha256 = "Za+7K93pgnuEUQ+jDItEzWlN0izhbynX2crSOXBBY/I=";
    })
    # Fix build on armv7l.
    # see also https://bugs.kde.org/show_bug.cgi?id=454346
    (fetchpatch {
      url = "https://git.yoctoproject.org/poky/plain/meta/recipes-devtools/valgrind/valgrind/use-appropriate-march-mcpu-mfpu-for-ARM-test-apps.patch?id=b7a9250590a16f1bdc8c7b563da428df814d4292";
      sha256 = "sha256-sBZzn98Sf/ETFv8ubivgA6Y6fBNcyR8beB3ICDAyAH0=";
    })
  ];

  outputs = [
    "out"
    "dev"
    "man"
    "doc"
  ];

  hardeningDisable = [
    "pie"
    "stackprotector"
  ];

  # GDB is needed to provide a sane default for `--db-command'.
  # Perl is needed for `callgrind_{annotate,control}'.
  buildInputs = [
    gdb
    perl
  ];

  # Perl is also a native build input.
  nativeBuildInputs = [
    autoreconfHook
    perl
  ];

  enableParallelBuilding = true;
  separateDebugInfo = stdenv.hostPlatform.isLinux;

  preConfigure = lib.optionalString stdenv.hostPlatform.isFreeBSD ''
    substituteInPlace configure --replace-fail '`uname -r`' ${stdenv.cc.libc.version}-
  '';

  configureFlags = lib.optional stdenv.hostPlatform.isx86_64 "--enable-only64bit";

  doCheck = true;

  postInstall = ''
    for i in $out/libexec/valgrind/*.supp; do
      substituteInPlace $i \
        --replace 'obj:/lib' 'obj:*/lib' \
        --replace 'obj:/usr/X11R6/lib' 'obj:*/lib' \
        --replace 'obj:/usr/lib' 'obj:*/lib'
    done
  '';

  passthru = {
    updateScript = writeScript "update-valgrind" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p curl pcre common-updater-scripts

      set -eu -o pipefail

      # Expect the text in format of:
      #  'Current release: <a href="/downloads/current.html#current">valgrind-3.19.0</a>'
      new_version="$(curl -s https://valgrind.org/ |
          pcregrep -o1 'Current release: .*>valgrind-([0-9.]+)</a>')"
      update-source-version ${pname} "$new_version"
    '';
  };

  meta = {
    homepage = "https://valgrind.org/";
    description = "Debugging and profiling tool suite";

    longDescription = ''
      Valgrind is an award-winning instrumentation framework for
      building dynamic analysis tools.  There are Valgrind tools that
      can automatically detect many memory management and threading
      bugs, and profile your programs in detail.  You can also use
      Valgrind to build new tools.
    '';

    license = lib.licenses.gpl2Plus;

    maintainers = [ lib.maintainers.eelco ];
    platforms =
      with lib.platforms;
      lib.intersectLists (x86 ++ power ++ s390x ++ armv7 ++ aarch64 ++ mips ++ riscv64) (
        darwin ++ freebsd ++ illumos ++ linux
      );
    badPlatforms = [ lib.systems.inspect.platformPatterns.isStatic ];
    # See: <https://hydra.nixos.org/build/128521440/nixlog/2>
    #
    # Darwin‐specific derivation logic has been removed, check the
    # history if you want to fix this.
    broken = stdenv.hostPlatform.isDarwin;
  };
}

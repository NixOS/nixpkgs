{ lib
, stdenv
, fetchurl
, autoconf269
, automake
, libtool
, pkg-config
# libs
, cjson
, db
, gmp
, libxml2
, ncurses
# docs
, help2man
, texinfo
, texliveBasic
# test
}:

stdenv.mkDerivation rec {
  pname = "gnu-cobol";
  version = "3.2";

  src = fetchurl {
    url = "mirror://sourceforge/gnucobol/${lib.versions.majorMinor version}/gnucobol-${version}.tar.xz";
    hash = "sha256-O7SK9GztR3n6z0H9wu5g5My4bqqZ0BCzZoUxXfOcLuI=";
  };

  nativeBuildInputs = [
    pkg-config
    autoconf269
    automake
    libtool
    help2man
    texinfo
    texliveBasic
  ];

  buildInputs = [
    cjson
    db
    gmp
    libxml2
    ncurses
  ];

  outputs = [ "bin" "dev" "lib" "out" ];
  # XXX: Without this, we get a cycle between bin and dev
  propagatedBuildOutputs = [];

  # Skips a broken test
  postPatch = ''
    sed -i '/^AT_CHECK.*crud\.cob/i AT_SKIP_IF([true])' tests/testsuite.src/listings.at
    # upstream reports the following tests as known failures
    # test 843:
    sed -i '14180i\AT_SKIP_IF([true])' tests/testsuite.src/run_misc.at
    # test 875:
    sed -i '2894s/^/AT_SKIP_IF([true])/' tests/testsuite.src/run_file.at
  '';

  preConfigure = ''
    autoconf
    aclocal
    automake
  '' + lib.optionalString stdenv.isDarwin ''
    # when building with nix on darwin, configure will use GNU strip,
    # which fails due to using --strip-unneeded, which is not supported
    substituteInPlace configure --replace-fail '"GNU strip"' 'FAKE GNU strip'
  '';

  # error: call to undeclared function 'xmlCleanupParser'
  # ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
  env.CFLAGS = lib.optionalString stdenv.isDarwin "-Wno-error=implicit-function-declaration";

  enableParallelBuilding = true;

  installFlags = [ "install-pdf" "install-html" "localedir=$out/share/locale" ];

  # Tests must run after install.
  doCheck = false;

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    # Run tests
    TESTSUITEFLAGS="--jobs=$NIX_BUILD_CORES" make check

    # Sanity check
    message="Hello, COBOL!"
    # XXX: Don't for a second think you can just get rid of these spaces, they
    # are load bearing.
    tee hello.cbl <<EOF
           IDENTIFICATION DIVISION.
           PROGRAM-ID. HELLO.

           PROCEDURE DIVISION.
           DISPLAY "$message".
           STOP RUN.
    EOF
    $bin/bin/cobc -x -o hello-cobol "hello.cbl"
    hello="$(./hello-cobol | tee >(cat >&2))"
    [[ "$hello" == "$message" ]] || exit 1

    runHook postInstallCheck
  '';

  meta = with lib; {
    description = "Open-source COBOL compiler";
    homepage = "https://sourceforge.net/projects/gnucobol/";
    license = with licenses; [ gpl3Only lgpl3Only ];
    maintainers = with maintainers; [ ericsagnes lovesegfault techknowlogick ];
    platforms = platforms.all;
  };
}

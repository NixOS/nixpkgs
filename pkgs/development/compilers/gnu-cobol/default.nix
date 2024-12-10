{
  lib,
  stdenv,
  fetchurl,
  autoconf269,
  automake,
  libtool,
  # libs
  cjson,
  db,
  gmp,
  libxml2,
  ncurses,
  # docs
  help2man,
  texinfo,
  texliveBasic,
  # test
  writeText,
}:

stdenv.mkDerivation rec {
  pname = "gnu-cobol";
  version = "3.1.2";

  src = fetchurl {
    url = "mirror://sourceforge/gnucobol/${lib.versions.majorMinor version}/gnucobol-${version}.tar.xz";
    sha256 = "0x15ybfm63g7c9340fc6712h9v59spnbyaz4rf85pmnp3zbhaw2r";
  };

  nativeBuildInputs = [
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

  outputs = [
    "bin"
    "dev"
    "lib"
    "out"
  ];
  # XXX: Without this, we get a cycle between bin and dev
  propagatedBuildOutputs = [ ];

  # Skips a broken test
  postPatch = ''
    sed -i '/^AT_CHECK.*crud\.cob/i AT_SKIP_IF([true])' tests/testsuite.src/listings.at
  '';

  preConfigure = ''
    autoconf
    aclocal
    automake
  '';

  enableParallelBuilding = true;

  installFlags = [
    "install-pdf"
    "install-html"
    "localedir=$out/share/locale"
  ];

  # Tests must run after install.
  doCheck = false;

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    # Run tests
    make -j$NIX_BUILD_CORES check

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
    description = "An open-source COBOL compiler";
    homepage = "https://sourceforge.net/projects/gnucobol/";
    license = with licenses; [
      gpl3Only
      lgpl3Only
    ];
    maintainers = with maintainers; [
      ericsagnes
      lovesegfault
    ];
    platforms = platforms.all;
  };
}

{ stdenv
, lib
, fetchFromGitHub
, bison
, flex
, readline
, getopt
}:

stdenv.mkDerivation rec {
  pname = "chaos";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "chaos-lang";
    repo = pname;
    rev = "v${version}";
    sha256 = "ts+kzM+yesCS1JLyMkxT/7hHKpCtYxtwIuhyM2w3frc=";
  };

  nativeBuildInputs = [
    bison flex
  ];

  buildInputs = [
    readline
    stdenv.cc
  ];

  checkInputs = [
    getopt
  ];

  postPatch = ''
    sed -i Makefile \
        -e 's/\({CHAOS_EXTRA_FLAGS}\)/\1 -Wno-error=unused-result/' \
        -e 's/rsync -av/cp -r/' \
        -e "s,/usr/local,$out," \
        -e '/~\//d'
    sed -i compiler/compiler.c utilities/messages.c \
        -e "s,/usr/local,$out,"
  '';

  patches = [
    ./0001-add-Wno-error-unused-result-to-compiler-flags.patch
  ];

  buildFlags = lib.optional stdenv.cc.isClang "clang";

  doCheck = true;

  preCheck = ''
    patchShebangs tests/*.sh tests/shell/*.sh
    sed -i tests/interpreter.sh tests/shell/interpreter.sh \
        -e '/test=/s,chaos,/build/source/chaos,' \
        -e 's,\.\*\\/chaos,.*/build/source,'
  '';

  checkTarget = "test";

  preInstall = ''
    mkdir -p $out/bin
  '';

  doInstallCheck = true;

  preInstallCheck = ''
    sed -i tests/compiler.sh \
        -e "/cout=/s,chaos,$out/bin/chaos,"
  '';

  installCheckTarget = "test-compiler";
}

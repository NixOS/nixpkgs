{ lib
, mkDerivation
, fetchFromGitHub
, cmake
, pkg-config
, cppunit
, swig3
, boost
, logLib
, python
, libsodium
, gnuradioAtLeast
}:

mkDerivation {
  pname = "gr-nacl";
  version = "2017-04-10";
  src = fetchFromGitHub {
    owner = "stwunsch";
    repo = "gr-nacl";
    rev = "15276bb0fcabf5fe4de4e58df3d579b5be0e9765";
    sha256 = "018np0qlk61l7mlv3xxx5cj1rax8f1vqrsrch3higsl25yydbv7v";
  };
  disabled = gnuradioAtLeast "3.8";

  nativeBuildInputs = [
    cmake
    pkg-config
    swig3
    python
  ];

  buildInputs = [
    cppunit
    logLib
    boost
    libsodium
  ];

  meta = with lib; {
    description = "Gnuradio block for encryption";
    homepage = "https://github.com/stwunsch/gr-nacl";
    license = licenses.gpl3Plus;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ mog ];
  };
}

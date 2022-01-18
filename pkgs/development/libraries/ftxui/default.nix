{ lib
, stdenv
, fetchFromGitHub
, cmake
, doxygen
, graphviz
}:

stdenv.mkDerivation rec {
  pname = "ftxui";
  version = "unstable-2021-08-13";

  src = fetchFromGitHub {
    owner = "ArthurSonzogni";
    repo = pname;
    rev = "69b0c9e53e523ac43a303964fc9c5bc0da7d5d61";
    sha256 = "0cbljksgy1ckw34h0mq70s8sma0p16sznn4z9r4hwv76y530m0ww";
  };

  nativeBuildInputs = [
    cmake
    doxygen
    graphviz
  ];

  meta = with lib; {
    homepage = "https://github.com/ArthurSonzogni/FTXUI";
    description = "Functional Terminal User Interface for C++";
    license = licenses.mit;
    maintainers = [ maintainers.ivar ];
    platforms = platforms.unix;
  };
}

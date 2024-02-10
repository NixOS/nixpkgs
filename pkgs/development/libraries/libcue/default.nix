{ lib, stdenv, fetchFromGitHub, cmake, bison, flex }:

stdenv.mkDerivation rec {
  pname = "libcue";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "lipnitsk";
    repo = "libcue";
    rev = "v${version}";
    hash = "sha256-ZMUUa8CmpFNparPsM/P2yvRto9E85EdTxpID5sKQbNI=";
  };

  nativeBuildInputs = [ cmake bison flex ];

  doCheck = true;

  meta = with lib; {
    description = "CUE Sheet Parser Library";
    longDescription = ''
      libcue is intended to parse a so called cue sheet from a char string or
      a file pointer. For handling of the parsed data a convenient API is
      available.
    '';
    homepage = "https://github.com/lipnitsk/libcue";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ astsmtl ];
    platforms = platforms.unix;
  };
}

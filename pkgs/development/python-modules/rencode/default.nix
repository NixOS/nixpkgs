{ lib
, buildPythonPackage
, fetchFromGitHub
, cython
}:

buildPythonPackage rec {
  pname = "rencode";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "aresch";
    repo = "rencode";
    rev = "v${version}";
    sha256 = "sha256-tL2ChS1CIOipST08+uy8V7EyVwii1IwPis8mLtsQ3EA=";
  };

  buildInputs = [ cython ];

  meta = with lib; {
    homepage = "https://github.com/aresch/rencode";
    description = "Fast (basic) object serialization similar to bencode";
    license = licenses.gpl3;
  };

}

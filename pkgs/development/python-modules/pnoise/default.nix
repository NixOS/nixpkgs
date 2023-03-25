{ lib
, buildPythonPackage
, fetchFromGitHub
, numpy
, pytestCheckHook
}:

buildPythonPackage rec {
  version = "0.2.0";
  pname = "pnoise";

  src = fetchFromGitHub {
    owner = "plottertools";
    repo = pname;
    rev = version;
    sha256 = "sha256-JwWzLvgCNSLRs/ToZNFH6fN6VLEsQTmsgxxkugwjA9k=";
  };

  propagatedBuildInputs = [ numpy ];

  nativeCheckInputs = [ pytestCheckHook ];
  pythonImportsCheck = [ "pnoise" ];

  meta = with lib; {
    description = "pnoise is a pure-Python, Numpy-based, vectorized port of Processing's noise() function";
    homepage = "https://github.com/plottertools/pnoise";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ sdedovic ];
  };
}

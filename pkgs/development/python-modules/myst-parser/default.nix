{ lib
, buildPythonPackage
, fetchPypi
, markdown-it-py
, pyyaml
, docutils
, sphinx
, pythonOlder
}:

buildPythonPackage rec {
  pname = "myst-parser";
  version = "0.12.10";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4612c46196e0344bb7e49dbc3deb288f9b9a88fcf6e9f210f7f3ea5bc9899bfc";
  };

  propagatedBuildInputs = [
    markdown-it-py
    pyyaml
    docutils
    sphinx
  ];

  meta = with lib; {
    description = "An extended commonmark compliant parser, with bridges to docutils & sphinx";
    homepage = https://github.com/executablebooks/MyST-Parser;
    license = licenses.mit;
  };
}
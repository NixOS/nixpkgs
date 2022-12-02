{ lib
, buildPythonPackage
, fetchPypi
, termcolor
, pytest
, packaging
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pytest-sugar";
  version = "0.9.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-7qeLbxW2NSd9PZAoDNOG2P7qHKsPm+dZR6Ym6LArR30=";
  };

  buildInputs = [ pytest ];

  propagatedBuildInputs = [
    termcolor
    packaging
  ];

  checkInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "A plugin that changes the default look and feel of py.test";
    homepage = "https://github.com/Frozenball/pytest-sugar";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}

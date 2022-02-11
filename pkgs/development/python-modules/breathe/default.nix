{ lib
, buildPythonPackage
, docutils
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, sphinx
}:

buildPythonPackage rec {
  pname = "breathe";
  version = "4.32.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "michaeljones";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-U85iLVS6bmA2Ty0AC4z2qODy9u4rWg6Nb42/k2Ix+kk=";
  };

  propagatedBuildInputs = [
    docutils
    sphinx
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "breathe"
  ];

  meta = with lib; {
    description = "Sphinx Doxygen renderer";
    homepage = "https://github.com/michaeljones/breathe";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
    inherit (sphinx.meta) platforms;
  };
}

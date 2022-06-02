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
  version = "4.33.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "michaeljones";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-S4wxlxluRjwlRGCa5Os/J3EpdekI/CEPMWw6j/wlZbw=";
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

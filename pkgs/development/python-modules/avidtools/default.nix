{ lib
, buildPythonPackage
, datetime
, fetchPypi
, nvdlib
, pydantic
, pythonOlder
, setuptools
, typing
, typing-extensions
}:

buildPythonPackage rec {
  pname = "avidtools";
  version = "0.1.1.2";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-t+ohPjOBwY8i+g7VC30ehEu6SFIsn1SwGR/ICkV9blg=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    datetime
    nvdlib
    pydantic
    typing
    typing-extensions
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "avidtools"
  ];

  meta = with lib; {
    description = "Developer tools for AVID";
    homepage = "https://github.com/avidml/avidtools";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}

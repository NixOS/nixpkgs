{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, click
, six
, pytestCheckHook
, jsonschema
}:

buildPythonPackage rec {
  pname = "archspec";
  version = "0.1.4";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-ScigEpYNArveqi5tlqiA7LwsVs2RkjT+GChxhSy/ndw=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    click
    six
  ];

  checkInputs = [
    pytestCheckHook
    jsonschema
  ];

  pythonImportsCheck = [
    "archspec"
  ];

  meta = with lib; {
    description = "Library for detecting, labeling, and reasoning about microarchitectures";
    homepage = "https://archspec.readthedocs.io/";
    changelog = "";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ atila ];
  };
}

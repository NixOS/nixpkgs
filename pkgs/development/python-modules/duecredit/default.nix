{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, setuptools
, pytestCheckHook
, vcrpy
, citeproc-py
, requests
}:

buildPythonPackage rec {
  pname = "duecredit";
  version = "0.9.3";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-+DeOqQ0R+XUlkuSHySFj2oDZqf85mT64PAi/LtTso3I=";
  };

  nativeBuildInputs = [ setuptools ];
  propagatedBuildInputs = [ citeproc-py requests ];

  nativeCheckInputs = [ pytestCheckHook vcrpy ];
  disabledTests = [ "test_import_doi" ];  # tries to access network

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  pythonImportsCheck = [ "duecredit" ];

  meta = with lib; {
    homepage = "https://github.com/duecredit/duecredit";
    description = "Simple framework to embed references in code";
    changelog = "https://github.com/duecredit/duecredit/releases/tag/${version}";
    license = licenses.bsd2;
    maintainers = with maintainers; [ bcdarwin ];
  };
}

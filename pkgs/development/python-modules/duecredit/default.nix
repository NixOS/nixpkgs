{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, setuptools
, pytestCheckHook
, vcrpy
, citeproc-py
, requests
, six
}:

buildPythonPackage rec {
  pname = "duecredit";
  version = "0.9.2";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Dg/Yfp5GzmyUMI6feAwgP+g22JYoQE+L9a+Wp0V77Rw=";
  };

  nativeBuildInputs = [ setuptools ];
  propagatedBuildInputs = [ citeproc-py requests six ];

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

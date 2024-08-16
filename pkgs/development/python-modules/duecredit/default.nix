{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools,
  pytestCheckHook,
  vcrpy,
  citeproc-py,
  looseversion,
  requests,
}:

buildPythonPackage rec {
  pname = "duecredit";
  version = "0.10.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-/nOiDk+7LZcroB7fN97BsLoeZG7+XvTMrwxnJMoofUI=";
  };

  postPatch = ''
    substituteInPlace tox.ini  \
      --replace-fail "--cov=duecredit" ""  \
      --replace-fail "--cov-config=tox.ini" ""
  '';

  nativeBuildInputs = [ setuptools ];
  propagatedBuildInputs = [
    citeproc-py
    looseversion
    requests
  ];

  nativeCheckInputs = [
    pytestCheckHook
    vcrpy
  ];
  disabledTests = [ "test_import_doi" ]; # tries to access network

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  pythonImportsCheck = [ "duecredit" ];

  meta = {
    homepage = "https://github.com/duecredit/duecredit";
    description = "Simple framework to embed references in code";
    mainProgram = "duecredit";
    changelog = "https://github.com/duecredit/duecredit/releases/tag/${version}";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.bcdarwin ];
  };
}

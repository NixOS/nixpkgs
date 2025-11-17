{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  html-text,
  jstyleson,
  lxml,
  mf2py,
  mock,
  pyrdfa3,
  pytestCheckHook,
  pythonOlder,
  rdflib,
  setuptools,
  six,
  w3lib,
}:

buildPythonPackage rec {
  pname = "extruct";
  version = "0.18.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "scrapinghub";
    repo = "extruct";
    tag = "v${version}";
    hash = "sha256-hUSlIlWxrsxGLCE8/DAGSqxx9+7TEkynmXrVnXGjDQ8=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    html-text
    jstyleson
    lxml
    mf2py
    pyrdfa3
    rdflib
    six
    w3lib
  ];

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "extruct" ];

  disabledTests = [
    # AssertionError: Lists differ
    "test_microformat"
    "test_umicroformat"
  ];

  meta = with lib; {
    description = "Extract embedded metadata from HTML markup";
    mainProgram = "extruct";
    homepage = "https://github.com/scrapinghub/extruct";
    changelog = "https://github.com/scrapinghub/extruct/blob/v${version}/HISTORY.rst";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ambroisie ];
  };
}

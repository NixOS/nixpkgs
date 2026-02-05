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
  rdflib,
  setuptools,
  six,
  w3lib,
}:

buildPythonPackage (finalAttrs: {
  pname = "extruct";
  version = "0.18.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "scrapinghub";
    repo = "extruct";
    tag = "v${finalAttrs.version}";
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

  meta = {
    description = "Extract embedded metadata from HTML markup";
    mainProgram = "extruct";
    homepage = "https://github.com/scrapinghub/extruct";
    changelog = "https://github.com/scrapinghub/extruct/blob/v${finalAttrs.version}/HISTORY.rst";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ ambroisie ];
  };
})

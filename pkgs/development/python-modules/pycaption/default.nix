{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  beautifulsoup4,
  lxml,
  cssutils,
  nltk,
  pytest-lazy-fixture,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "pycaption";
  version = "2.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pbs";
    repo = "pycaption";
    tag = finalAttrs.version;
    hash = "sha256-nkxdsAiRwWTjPCvXFfvy4COqI3ma1Lr64MRYXIL14dM=";
  };

  build-system = [ setuptools ];

  dependencies = [
    beautifulsoup4
    lxml
    cssutils
  ];

  optional-dependencies = {
    transcript = [ nltk ];
  };

  nativeCheckInputs = [
    pytest-lazy-fixture
    pytestCheckHook
  ];

  meta = {
    changelog = "https://github.com/pbs/pycaption/blob/${finalAttrs.src.tag}/docs/changelog.rst";
    description = "Closed caption converter";
    homepage = "https://github.com/pbs/pycaption";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
})

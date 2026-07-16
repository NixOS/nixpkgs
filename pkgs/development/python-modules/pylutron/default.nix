{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
  telnetlib3,
}:

buildPythonPackage (finalAttrs: {
  pname = "pylutron";
  version = "0.4.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "thecynic";
    repo = "pylutron";
    tag = finalAttrs.version;
    hash = "sha256-W0QiOiaUh2/kNNxdPlQLyc4HorDAxZLc+zsftNC0Ah4=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail TEMPLATE_VERSION ${finalAttrs.version}
  '';

  build-system = [ setuptools ];

  dependencies = [ telnetlib3 ];

  pythonImportsCheck = [ "pylutron" ];

  nativeCheckInputs = [ pytestCheckHook ];

  enabledTestPaths = [ "tests" ];

  meta = {
    description = "Python library for controlling a Lutron RadioRA 2 system";
    homepage = "https://github.com/thecynic/pylutron";
    changelog = "https://github.com/thecynic/pylutron/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})

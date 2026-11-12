{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  hpack,
  hyperframe,
  pytestCheckHook,
  hypothesis,
}:

buildPythonPackage rec {
  pname = "h2";
  version = "4.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "python-hyper";
    repo = "h2";
    tag = "v${version}";
    hash = "sha256-ezyvCgsMYfu4s9BH6K60sFflyw29NEN3rSlxAkDOdvs=";
  };

  build-system = [ setuptools ];

  dependencies = [
    hpack
    hyperframe
  ];

  nativeCheckInputs = [
    pytestCheckHook
    hypothesis
  ];

  disabledTests = [
    # timing sensitive
    "test_changing_max_frame_size"
  ];

  pythonImportsCheck = [
    "h2.connection"
    "h2.config"
  ];

  meta = {
    changelog = "https://github.com/python-hyper/h2/blob/${src.tag}/CHANGELOG.rst";
    description = "HTTP/2 State-Machine based protocol implementation";
    homepage = "https://github.com/python-hyper/h2";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}

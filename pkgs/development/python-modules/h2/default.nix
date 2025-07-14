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
  version = "4.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "python-hyper";
    repo = "h2";
    tag = "v${version}";
    hash = "sha256-rfCwMn2msiRoIvhsdK6hyp3BjDy5AGziX4Or0cb9bKc=";
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

  meta = with lib; {
    changelog = "https://github.com/python-hyper/h2/blob/${src.tag}/CHANGELOG.rst";
    description = "HTTP/2 State-Machine based protocol implementation";
    homepage = "https://github.com/python-hyper/h2";
    license = licenses.mit;
    maintainers = [ ];
  };
}

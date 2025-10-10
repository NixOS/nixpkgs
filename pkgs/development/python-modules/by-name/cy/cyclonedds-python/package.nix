{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  cyclonedds,
  setuptools,
  rich-click,

  pytestCheckHook,
  pytest-mock,
  pytest-cov-stub,
}:

buildPythonPackage rec {
  pname = "cyclonedds-python";
  version = "0.10.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "eclipse-cyclonedds";
    repo = "cyclonedds-python";
    tag = version;
    hash = "sha256-MN3Z5gqsD+cr5Awmsia9+uCHL/a2KQP2uMS13rVc1Hw=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
        --replace-fail "pytest-cov" ""
  '';

  build-system = [ setuptools ];

  buildInputs = [ cyclonedds ];

  dependencies = [ rich-click ];

  env.CYCLONEDDS_HOME = "${cyclonedds.out}";

  nativeCheckInputs = [
    pytestCheckHook
    pytest-mock
    pytest-cov-stub
  ];

  meta = {
    description = "Python binding for Eclipse Cyclone DDS";
    homepage = "https://github.com/eclipse-cyclonedds/cyclonedds-python";
    changelog = "https://github.com/eclipse-cyclonedds/cyclonedds-python/releases/tag/${version}";
    license = lib.licenses.epl20;
    maintainers = with lib.maintainers; [ kvik ];
  };
}

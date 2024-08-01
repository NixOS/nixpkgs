{ lib
, buildPythonPackage
, fetchFromGitHub

, cyclonedds
, setuptools
, rich-click

, pytestCheckHook
, pytest-mock
}:

buildPythonPackage rec {
  pname = "cyclonedds-python";
  version = "0.10.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "eclipse-cyclonedds";
    repo = "cyclonedds-python";
    rev = "refs/tags/${version}";
    hash = "sha256-MN3Z5gqsD+cr5Awmsia9+uCHL/a2KQP2uMS13rVc1Hw=";
  };

  postPatch = ''
    sed -i 's/^addopts.*/addopts = "-ra --import-mode=importlib"/' pyproject.toml
    sed -i '/^required_plugins/ s/pytest-cov//' pyproject.toml
  '';

  build-system = [ setuptools ];

  buildInputs = [ cyclonedds ];

  dependencies = [ rich-click ];

  env.CYCLONEDDS_HOME = "${cyclonedds.out}";

  nativeCheckInputs = [
    pytestCheckHook
    pytest-mock
  ];

  meta = {
    description = "Python binding for Eclipse Cyclone DDS";
    homepage = "https://github.com/eclipse-cyclonedds/cyclonedds-python";
    changelog = "https://github.com/eclipse-cyclonedds/cyclonedds-python/releases/tag/${version}";
    license = lib.licenses.epl20;
    maintainers = with lib.maintainers; [ kvik ];
  };
}

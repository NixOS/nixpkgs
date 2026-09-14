{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  mcap,
  pytestCheckHook,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "mcap-ros2-support";
  version = "1.3.1"; # Replace with the specific version you need
  pyproject = true;

  src = fetchFromGitHub {
    owner = "foxglove";
    repo = "mcap";
    rev = "releases/python/mcap/v${version}";
    hash = "sha256-3H36Q9JDxC44UnIdgtCMAkeT3+tEOloxAI7fext2YXk=";
    fetchLFS = true;
  };

  sourceRoot = "source/python/mcap-ros2-support";

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    mcap
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  doCheck = true;
  pythonImportsCheck = [ "mcap_ros2" ];

  meta = with lib; {
    description = "mcap-ros2-support Python library";
    homepage = "https://mcap.dev/";
    downloadPage = "https://github.com/foxglove/mcap/tree/main/python/mcap-ros2-support";
    license = licenses.mit;
    maintainers = with lib.maintainers; [ guelakais ];
  };
}

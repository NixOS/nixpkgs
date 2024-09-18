{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
  stevedore,
  wheel,
}:

buildPythonPackage rec {
  pname = "plux";
  version = "1.11.0";
  pyproject = true;

  # Tests are not available from PyPi
  src = fetchFromGitHub {
    owner = "localstack";
    repo = "plux";
    rev = "refs/tags/v${version}";
    hash = "sha256-M4N3Ccuw95OcLsWQVtITv4QShBJKliTh5QIoqji8x9o=";
  };

  build-system = [
    setuptools
    wheel
  ];

  dependencies = [ stevedore ];

  nativeCheckInputs = [ pytestCheckHook ];

  preCheck = ''
    export HOME=$TMPDIR
  '';

  pythonImportsCheck = [ "plugin.core" ];

  meta = with lib; {
    description = "Dynamic code loading framework for building pluggable Python distributions";
    homepage = "https://github.com/localstack/plux";
    license = licenses.asl20;
    maintainers = [ ];
  };
}

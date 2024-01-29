{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, pytestCheckHook
, setuptools
, stevedore
, wheel
}:

buildPythonPackage rec {
  pname = "plux";
  version = "1.4.0";
  format = "pyproject";

  # Tests are not available from PyPi
  src = fetchFromGitHub {
    owner = "localstack";
    repo = "plux";
    rev = "refs/tags/v${version}";
    hash = "sha256-AybMHkCUNJsL51XwiskkIltEtqZ27fGHrpyct8IUjmo=";
  };

  patches = [
    # https://github.com/localstack/plux/pull/8
    (fetchpatch {
      name = "remove-pytest-runner.patch";
      url = "https://github.com/localstack/plux/commit/3cda22e51f43a86304d0dedd7e554b21aa82c8b0.patch";
      hash = "sha256-ZFHUTkUYFSTgKbx+c74JQzre0la+hFW9gNOxOehvVoE=";
    })
  ];

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    stevedore
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "plugin.core" ];

  meta = with lib; {
    description = "Dynamic code loading framework for building pluggable Python distributions";
    homepage = "https://github.com/localstack/plux";
    license = licenses.asl20;
    maintainers = with maintainers; [ jonringer ];
  };
}

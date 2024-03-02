{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, setuptools
, wheel
}:

buildPythonPackage rec {
  pname = "dllogger";
  version = "1.0.0";
  pyproject = true;

  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "dllogger";
    rev = "refs/tags/v${version}";
    hash = "sha256-Hpr4yeRl+Dyaz6lRyH/5P6UQT184JEHPqgVlf4qHvOg=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  # use examples as smoke tests since upstream has no tests
  checkPhase = ''
    runHook preCheck

    python examples/dllogger_example.py
    python examples/dllogger_singleton_example.py

    runHook postCheck
  '';

  pythonImportsCheck = [ "dllogger" ];

  meta = with lib; {
    description = "A logging tool for deep learning";
    homepage = "https://github.com/NVIDIA/dllogger";
    changelog = "https://github.com/NVIDIA/dllogger/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ natsukium ];
  };
}

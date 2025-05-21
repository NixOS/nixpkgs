{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
  wheel,
}:

buildPythonPackage rec {
  pname = "dllogger";
  version = "1.1.0";
  pyproject = true;

  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "dllogger";
    tag = "v${version}";
    hash = "sha256-kT6FhAl4JZlFPdzKYopAJBurYVMaU5umn/qZADfPjkE=";
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
    description = "Logging tool for deep learning";
    homepage = "https://github.com/NVIDIA/dllogger";
    changelog = "https://github.com/NVIDIA/dllogger/releases/tag/${src.tag}";
    license = licenses.asl20;
    maintainers = with maintainers; [ natsukium ];
  };
}

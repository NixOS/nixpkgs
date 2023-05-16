{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "prometheus-client";
<<<<<<< HEAD
  version = "0.17.1";
=======
  version = "0.16.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "prometheus";
    repo = "client_python";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-ag9gun47Ar0Sw3ZGIXAHjtv4GdhX8x51UVkgwdQ8A+s=";
  };

  __darwinAllowLocalNetworking = true;

=======
    hash = "sha256-FYQE0toy5VFKNVadSsxG/5NCRANYJOcVR4bGPrCAxvc=";
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "prometheus_client"
  ];

  meta = with lib; {
    description = "Prometheus instrumentation library for Python applications";
    homepage = "https://github.com/prometheus/client_python";
    changelog = "https://github.com/prometheus/client_python/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}

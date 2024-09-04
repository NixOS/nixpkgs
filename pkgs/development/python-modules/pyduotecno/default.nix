{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyduotecno";
  version = "2024.5.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "Cereal2nd";
    repo = "pyDuotecno";
    rev = "refs/tags/${version}";
    hash = "sha256-huzv7f1Aq/n3cD9S4oXqGQogq7VpPpzAUqkOhiB879A=";
  };

  build-system = [ setuptools ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "duotecno" ];

  meta = with lib; {
    description = "Module to interact with Duotecno IP interfaces";
    homepage = "https://github.com/Cereal2nd/pyDuotecno";
    changelog = "https://github.com/Cereal2nd/pyDuotecno/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}

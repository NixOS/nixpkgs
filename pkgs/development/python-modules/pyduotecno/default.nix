{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyduotecno";
  version = "2024.5.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "Cereal2nd";
    repo = "pyDuotecno";
    rev = "refs/tags/${version}";
    hash = "sha256-59dwSr/IlNmHoJnPEBTR2FOXZ8JiFIo1V69/r0yxKNM=";
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

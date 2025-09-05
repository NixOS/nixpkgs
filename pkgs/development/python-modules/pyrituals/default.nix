{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyrituals";
  version = "0.0.7";
  format = "pyproject";
  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "milanmeu";
    repo = "pyrituals";
    rev = version;
    sha256 = "sha256-nCyfwOONtpwRLFq3crRacmrWef6J3mOfKz4fvkOcb3g=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ aiohttp ];

  # Project has no tests
  doCheck = false;
  pythonImportsCheck = [ "pyrituals" ];

  meta = with lib; {
    description = "Python wrapper for the Rituals Perfume Genie API";
    homepage = "https://github.com/milanmeu/pyrituals";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}

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
  version = "0.0.6";
  format = "pyproject";
  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "milanmeu";
    repo = pname;
    rev = version;
    sha256 = "0ynjz7khp67bwxjp580w3zijxr9yn44nmnbvkxjxq9scyb2mjf6g";
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

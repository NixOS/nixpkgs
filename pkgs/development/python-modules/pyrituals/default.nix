{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pyrituals";
  version = "0.0.5";
  format = "pyproject";
  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "milanmeu";
    repo = pname;
    rev = version;
    sha256 = "sha256-iWJhjAUXkoH3MMJ5PFj2rjIy2e0nn57cRoEF6KMfrQg=";
  };

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

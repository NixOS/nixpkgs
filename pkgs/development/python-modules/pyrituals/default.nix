{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pyrituals";
  version = "0.0.2";
  format = "pyproject";
  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "milanmeu";
    repo = pname;
    rev = version;
    sha256 = "0hrwhk3kpvdg78fgnvhmnnh3wprdv10j8jqjm4ly64chr8cdi6f2";
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

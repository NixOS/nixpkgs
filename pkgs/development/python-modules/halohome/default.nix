{
  lib,
  aiohttp,
  bleak,
  buildPythonPackage,
  csrmesh,
  fetchFromGitHub,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "halohome";
  version = "0.5.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "nayaverdier";
    repo = pname;
    rev = version;
    hash = "sha256-xnUOObqVg1E7mTDKHZMoC95KI9ZIn0YpkQjoASa5Dds=";
  };

  propagatedBuildInputs = [
    aiohttp
    bleak
    csrmesh
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "halohome" ];

  meta = with lib; {
    description = "Python library to control Eaton HALO Home Smart Lights";
    homepage = "https://github.com/nayaverdier/halohome";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}

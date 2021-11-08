{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, iso4217
, pytestCheckHook
, pythonOlder
, pytz
}:

buildPythonPackage rec {
  pname = "pyefergy";
  version = "0.1.3";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "tkdrob";
    repo = pname;
    rev = version;
    sha256 = "sha256-TGvS/ntIRbkcMsD5y0QdqyLE2dcPUbX3d79jHc3ddd0=";
  };

  propagatedBuildInputs = [
    aiohttp
    iso4217
    pytz
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "pyefergy" ];

  meta = with lib; {
    description = "Python API library for Efergy energy meters";
    homepage = "https://github.com/tkdrob/pyefergy";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}

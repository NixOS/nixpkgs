{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  numpy,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "airtouch4pyapi";
  version = "1.0.8";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "LonePurpleWolf";
    repo = "airtouch4pyapi";
    tag = "v${version}";
    hash = "sha256-RiRwebumidn0nijL/e9J74ZYx0DASi1up5BTNxYoGEA=";
  };

  propagatedBuildInputs = [ numpy ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "airtouch4pyapi" ];

  meta = with lib; {
    description = "Python API for Airtouch 4 controllers";
    homepage = "https://github.com/LonePurpleWolf/airtouch4pyapi";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}

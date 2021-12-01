{ lib
, buildPythonPackage
, colorlog
, demjson
, fetchPypi
, pythonOlder
, requests
}:

buildPythonPackage rec {
  pname = "lupupy";
  version = "0.0.21";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0cpamb1fp84psiqm7xr156zi4f2fv2wijbjjyk6w87z8fl2aw8xc";
  };

  propagatedBuildInputs = [
    colorlog
    demjson
    requests
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "lupupy" ];

  meta = with lib; {
    description = "Python module to control Lupusec alarm control panels";
    homepage = "https://github.com/majuss/lupupy";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}

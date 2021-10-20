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
  version = "0.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "tkdrob";
    repo = pname;
    rev = version;
    sha256 = "0nm7dc5q4wvdpqxpirlc4nwm68lf3n2df6j5yy4m8wr294yb7a1k";
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

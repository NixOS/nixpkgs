{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "pylutron";
  version = "0.2.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c305530e9a114ff4c8261a116a9d13d356bc82662dfaf7ca73e01346cea9841e";
  };

  # Project has no tests
  doCheck = false;
  pythonImportsCheck = [ "pylutron" ];

  meta = with lib; {
    description = "Python library for controlling a Lutron RadioRA 2 system";
    homepage = "https://github.com/thecynic/pylutron";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}

{ lib, buildPythonPackage, fetchPypi, isPy27, pythonAtLeast
, coverage, nose, pbkdf2 }:

buildPythonPackage rec {
  pname = "cryptacular";
  version = "1.6.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7b529cb2b8a3c7e5be77921bf1ebc653d4d3a8f791375cc6f971b20db2404176";
  };

  buildInputs = [ coverage nose ];
  propagatedBuildInputs = [ pbkdf2 ];

  # TODO: tests fail: TypeError: object of type 'NoneType' has no len()
  doCheck = false;

  # Python >=2.7.15, >=3.6.5 are incompatible:
  # https://bitbucket.org/dholth/cryptacular/issues/11
  disabled = isPy27 || pythonAtLeast "3.6";

  meta = with lib; {
    maintainers = with maintainers; [ domenkozar ];
  };
}

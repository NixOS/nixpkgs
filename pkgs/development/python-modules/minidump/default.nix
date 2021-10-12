{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "minidump";
  version = "0.0.20";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1rr91nnlzv7gnbcvv8qhbyx1kh2s4jdv7nv0qka5jya32rzjaigm";
  };

  # Upstream doesn't have tests
  doCheck = false;
  pythonImportsCheck = [ "minidump" ];

  meta = with lib; {
    description = "Python library to parse and read Microsoft minidump file format";
    homepage = "https://github.com/skelsec/minidump";
    license = with licenses; [ mit ];
    maintainers = [ maintainers.fab ];
  };
}

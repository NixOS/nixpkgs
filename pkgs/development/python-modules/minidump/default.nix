{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "minidump";
  version = "0.0.15";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-IVlzAsnl1KhErxWPi96hUFlIX4IN3Y9t8OicckdYUv0=";
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

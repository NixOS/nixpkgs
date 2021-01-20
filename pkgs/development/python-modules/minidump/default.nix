{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "minidump";
  version = "0.0.13";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1w93yh2dz7llxjgv0jn7gf9praz7d5952is7idgh0lsyj67ri2ms";
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

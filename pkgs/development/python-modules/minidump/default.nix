{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "minidump";
  version = "0.0.19";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Z7MyfLluMZYzZTo1PGKBcDdyM13IR5fW/c59rws74Hc=";
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

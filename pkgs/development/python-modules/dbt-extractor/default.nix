{ lib
, fetchPypi
, buildPythonPackage
, pythonOlder
, autopep8
}:

buildPythonPackage rec {
  pname = "dbt-extractor";
  version = "0.4.0";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "276ced7e9e3cb22e5d7c14748384a5cf5d9002257c0ed50c0e075b68011bb6d0";
  };

  buildInputs = [ autopep8 ];

  meta = with lib; {
    description = "Jinja processor utilities for dbt";
    homepage = "https://getdbt.com";
    license = licenses.asl20;
    maintainers = with maintainers; [ shikanime ];
  };
}

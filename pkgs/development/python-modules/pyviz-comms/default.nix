{ buildPythonPackage
, fetchPypi
, lib
, param
}:

buildPythonPackage rec {
  pname = "pyviz_comms";
  version = "0.7.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "cd9649a9ea9dfcb9b34d78f9a64e1870aa8b6b94de546e2c99c6bb53d64ab5d1";
  };

  requiredPythonModules = [ param ];

  # there are not tests with the package
  doCheck = false;

  meta = with lib; {
    description = "Launch jobs, organize the output, and dissect the results";
    homepage = "https://pyviz.org/";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}

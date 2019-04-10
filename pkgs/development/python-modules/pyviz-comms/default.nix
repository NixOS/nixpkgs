{ buildPythonPackage
, fetchPypi
, lib
, param
}:

buildPythonPackage rec {
  pname = "pyviz_comms";
  version = "0.7.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "045bjs8na3q0fy8zzq4pghyz05d9aid1lcv11992f62z2jrf6m2q";
  };

  propagatedBuildInputs = [ param ];

  # there are not tests with the package
  doCheck = false;

  meta = with lib; {
    description = "Launch jobs, organize the output, and dissect the results";
    homepage = http://pyviz.org/;
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}

{ buildPythonPackage
, fetchPypi
, lib
, param
}:

buildPythonPackage rec {
  pname = "pyviz_comms";
  version = "0.7.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c1722a496b08eb20ae3f2fedcc1ebcd207567b62e6453c7198a0b8f78ae96049";
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

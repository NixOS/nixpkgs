{ buildPythonPackage
, fetchPypi
, lib
, param
}:

buildPythonPackage rec {
  pname = "pyviz_comms";
  version = "2.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "be63957a49772895ddebeac02c697e1675e0bdf1515824f60fcc261914f23624";
  };

  propagatedBuildInputs = [ param ];

  # there are not tests with the package
  doCheck = false;

  meta = with lib; {
    description = "Launch jobs, organize the output, and dissect the results";
    homepage = "https://pyviz.org/";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}

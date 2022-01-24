{ buildPythonPackage
, fetchPypi
, lib
, param
, panel
}:

buildPythonPackage rec {
  pname = "pyviz_comms";
  version = "2.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f4a7126f318fb6b964fef3f92fa55bc46b9218f62a8464a8b18e968b3087dbc0";
  };

  propagatedBuildInputs = [ param ];

  # there are not tests with the package
  doCheck = false;

  pythonImportsCheck = [ "pyviz_comms" ];

  passthru.tests = {
    inherit panel;
  };

  meta = with lib; {
    description = "Launch jobs, organize the output, and dissect the results";
    homepage = "https://pyviz.org/";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}

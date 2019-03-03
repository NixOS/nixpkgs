{ buildPythonPackage
, fetchPypi
, lib
, param
}:

buildPythonPackage rec {
  pname = "pyviz_comms";
  version = "0.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7ad4ff0c2166f0296ee070049ce21341f868f907003714eb6eaf1630ea8e241a";
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

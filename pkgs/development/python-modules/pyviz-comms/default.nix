{ buildPythonPackage
, fetchPypi
, lib
, param
, panel
}:

buildPythonPackage rec {
  pname = "pyviz_comms";
  version = "2.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-uMncveAfOEeEP7TQTDs/TeeEkgxx5Eztnfu1YPbJIhg=";
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

{ buildPythonPackage
, fetchPypi
, lib
, param
, panel
}:

buildPythonPackage rec {
  pname = "pyviz_comms";
  version = "0.7.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-zZZJqeqd/LmzTXj5pk4YcKqLa5TeVG4smca7U9ZKtdE=";
  };

  propagatedBuildInputs = [ param ];

  # there are not tests with the package
  doCheck = false;

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

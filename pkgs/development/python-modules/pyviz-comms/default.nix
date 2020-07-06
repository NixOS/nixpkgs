{ buildPythonPackage
, fetchPypi
, lib
, param
}:

buildPythonPackage rec {
  pname = "pyviz_comms";
  version = "0.7.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1j93hjwh820hcspp3fxwll05cf2bpznwsmsp6479nlbvgpn5i9ys";
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

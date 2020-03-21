{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "httplib2";
  version = "0.17.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0qc2vn98a4icp3h04pdhiykddz5q6wfi905f19zfxl26kyjd15ny";
  };

  # Needs setting up
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/httplib2/httplib2";
    description = "A comprehensive HTTP client library";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}

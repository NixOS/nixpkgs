{ lib, buildPythonPackage, fetchPypi
, boto }:

buildPythonPackage rec {
  pname = "Area53";
  version = "0.94";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0v9b7f8b6v21y410anx5sr52k2ac8jrzdf19q6m6p0zsdsf9vr42";
  };

  # error: invalid command 'test'
  doCheck = false;

  propagatedBuildInputs = [ boto ];

  meta = with lib; {
    description = "Python Interface to Route53";
    homepage = https://github.com/mariusv/Area53;
    license = licenses.unfree; # unspecified
  };
}

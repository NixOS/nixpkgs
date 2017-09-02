{ stdenv, buildPythonPackage, fetchPypi
, boto }:

buildPythonPackage rec {
  pname = "Area53";
  version = "0.94";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0v9b7f8b6v21y410anx5sr52k2ac8jrzdf19q6m6p0zsdsf9vr42";
  };

  # error: invalid command 'test'
  doCheck = false;

  propagatedBuildInputs = [ boto ];
}

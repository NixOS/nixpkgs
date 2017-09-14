{ stdenv, buildPythonPackage, fetchPypi, certifi, six }:

buildPythonPackage rec {
  pname = "pylast";
  version = "1.9.0";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ae1c4105cbe704d9ac10ba57ac4c26bc576cc33978f1b578101b20c6a2360ca4";
  };

  propagatedBuildInputs = [ certifi six ];

  # tests require last.fm credentials
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://github.com/pylast/pylast;
    description = "A python interface to last.fm (and compatibles)";
    license = licenses.asl20;
    maintainers = with maintainers; [ rvolosatovs ];
  };
}

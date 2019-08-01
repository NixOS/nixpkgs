{ stdenv, buildPythonPackage, fetchPypi, isPy3k, certifi, six }:

buildPythonPackage rec {
  pname = "pylast";
  version = "3.1.0";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0sk08l8dq0r4xgmqkxq6jzlbam34k95adaw468n0bh6cps18ddby";
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

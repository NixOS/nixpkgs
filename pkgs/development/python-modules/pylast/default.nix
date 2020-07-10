{ stdenv, buildPythonPackage, fetchPypi, isPy3k, certifi, six
, setuptools_scm
}:

buildPythonPackage rec {
  pname = "pylast";
  version = "3.3.0";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1wqd23bbk5si2mcmswsi486zqnydjjf8g7924gcz6cc1x036lasd";
  };

  nativeBuildInputs = [ setuptools_scm ];
  propagatedBuildInputs = [ certifi six ];

  # tests require last.fm credentials
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = "https://github.com/pylast/pylast";
    description = "A python interface to last.fm (and compatibles)";
    license = licenses.asl20;
    maintainers = with maintainers; [ rvolosatovs ];
  };
}

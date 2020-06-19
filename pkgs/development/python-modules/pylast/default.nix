{ stdenv, buildPythonPackage, fetchPypi, isPy3k, certifi, six
, setuptools_scm
}:

buildPythonPackage rec {
  pname = "pylast";
  version = "3.2.1";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "3c984be04c9a22a884c3106a7f75749466d27c68870d6fb7e1f56b71becea7c0";
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

{ stdenv, buildPythonPackage, fetchPypi, isPy3k, certifi, six
, setuptools_scm
}:

buildPythonPackage rec {
  pname = "pylast";
  version = "4.0.0";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "8ec555d6c4c1b474e9b3c96c3786abd38303a1a5716d928b0f3cfdcb4499b093";
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

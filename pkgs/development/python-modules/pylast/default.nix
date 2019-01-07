{ stdenv, buildPythonPackage, fetchPypi, certifi, six }:

buildPythonPackage rec {
  pname = "pylast";
  version = "3.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0mmwx4l2kby4zvf3qvx8gmi6rnlhri70ipz9mvg8pw8z0591q194";
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

{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "first";
  version = "2.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1gykyrm6zlrbf9iz318p57qwk594mx1jf0d79v79g32zql45na7z";
  };

  doCheck = false; # no tests

  meta = with stdenv.lib; {
    description = "The function you always missed in Python";
    homepage = "https://github.com/hynek/first/";
    license = licenses.mit;
    maintainers = with maintainers; [ zimbatm ];
  };
}

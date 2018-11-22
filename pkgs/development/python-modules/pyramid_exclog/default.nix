{ stdenv
, buildPythonPackage
, fetchPypi
, pyramid
}:

buildPythonPackage rec {
  pname = "pyramid_exclog";
  version = "0.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a58c82866c3e1a350684e6b83b440d5dc5e92ca5d23794b56d53aac06fb65a2c";
  };

  propagatedBuildInputs = [ pyramid ];

  meta = with stdenv.lib; {
    description = "A package which logs to a Python logger when an exception is raised by a Pyramid application";
    homepage = http://docs.pylonsproject.org/;
    license = licenses.bsd0;
    maintainers = with maintainers; [ garbas domenkozar ];
  };

}

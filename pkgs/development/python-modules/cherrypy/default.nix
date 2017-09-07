{ stdenv, buildPythonPackage, fetchPypi, isPy3k
, pytest, setuptools_scm, pytestrunner
, six, cheroot, portend }:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "CherryPy";
  version = "11.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1037pvhab4my791vfzikm649ny52fj7x2q87cnncmbnqin6ghwan";
  };

  # wsgiserver.ssl_pyopenssl is broken on py3k.
  doCheck = !isPy3k;
  buildInputs = [ pytest setuptools_scm pytestrunner ];
  propagatedBuildInputs = [ six cheroot portend ];

  meta = with stdenv.lib; {
    homepage = "http://www.cherrypy.org";
    description = "A pythonic, object-oriented HTTP framework";
    license = licenses.bsd3;
  };
}

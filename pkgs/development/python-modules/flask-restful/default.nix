{ stdenv, buildPythonPackage, fetchPypi, isPy3k
, nose, mock, blinker
, flask, six, pytz, aniso8601, pycrypto
}:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "Flask-RESTful";
  version = "0.3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "01rlvl2iq074ciyn4schmjip7cyplkwkysbb8f610zil06am35ap";
  };

# TypeError: Only byte strings can be passed to C code
  patchPhase = if isPy3k then ''
    rm tests/test_crypto.py tests/test_paging.py
    '' else null;
  buildInputs = [ nose mock blinker ];
  propagatedBuildInputs = [ flask six pytz aniso8601 pycrypto ];
  PYTHON_EGG_CACHE = "`pwd`/.egg-cache";

  meta = with stdenv.lib; {
    homepage = "http://flask-restful.readthedocs.io/";
    description = "REST API building blocks for Flask";
    license = licenses.bsd3;
  };
}

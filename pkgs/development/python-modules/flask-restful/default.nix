{ lib, buildPythonPackage, fetchPypi, fetchpatch, isPy3k
, nose, mock, blinker, pytest
, flask, six, pytz, aniso8601, pycrypto
}:

buildPythonPackage rec {
  pname = "Flask-RESTful";
  version = "0.3.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "05b9lzx5yc3wgml2bcq50lq35h66m8zpj6dc9advcb5z3acsbaay";
  };

  propagatedBuildInputs = [ flask six pytz aniso8601 pycrypto ];

  checkInputs = [ pytest nose mock blinker ];

  # test_reqparse.py: werkzeug move Multidict location (only imported in tests)
  # handle_non_api_error isn't updated for addition encoding argument
  checkPhase = ''
    pytest --ignore=tests/test_reqparse.py -k 'not handle_non_api_error'
  '';

  meta = with lib; {
    homepage = "https://flask-restful.readthedocs.io/";
    description = "REST API building blocks for Flask";
    license = licenses.bsd3;
  };
}

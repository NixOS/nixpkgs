{ lib, buildPythonPackage, fetchPypi, fetchpatch, isPy3k
, nose, mock, blinker
, flask, six, pytz, aniso8601, pycrypto
}:

buildPythonPackage rec {
  pname = "Flask-RESTful";
  version = "0.3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "01rlvl2iq074ciyn4schmjip7cyplkwkysbb8f610zil06am35ap";
  };

  patches = [
    (fetchpatch {
      url = https://github.com/flask-restful/flask-restful/commit/54979f0a49b2217babc53c5b65b5df10b6de8e05.patch;
      sha256 = "11s6ag6l42g61ccg5jw9j1f26hwgjfa3sp890cbl5r4hy5ycpyr5";
    })
    (fetchpatch {
      url = https://github.com/flask-restful/flask-restful/commit/f45e81a45ed03922fd225afe27006315811077e6.patch;
      sha256 = "16avd369j5r08d1l23mwbba26zjwnmfqvfvnfz02am3gr5l6p3gl";
    })
  ];

  postPatch = lib.optionalString isPy3k ''
    # TypeError: Only byte strings can be passed to C code
    rm tests/test_crypto.py tests/test_paging.py
  '';

  checkInputs = [ nose mock blinker ];

  propagatedBuildInputs = [ flask six pytz aniso8601 pycrypto ];

  meta = with lib; {
    homepage = "https://flask-restful.readthedocs.io/";
    description = "REST API building blocks for Flask";
    license = licenses.bsd3;
  };
}

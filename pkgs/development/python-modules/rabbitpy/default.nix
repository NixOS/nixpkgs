{ stdenv
, buildPythonPackage
, fetchFromGitHub
, mock
, nose
, pamqp
}:

buildPythonPackage rec {
  version = "1.0.0";
  pname = "rabbitpy";

  # No tests in the pypi tarball, so we directly fetch from git
  src = fetchFromGitHub {
    owner = "gmr";
    repo = pname;
    rev = version;
    sha256 = "0fd80zlr4p2sh77rxyyfi9l0h2zqi2csgadr0rhnpgpqsy10qck6";
  };

  propagatedBuildInputs = [ pamqp ];
  checkInputs = [ mock nose ];

  checkPhase = ''
    runHook preCheck
    rm tests/integration_tests.py # Impure tests requiring network
    nosetests tests
    runHook postCheck
  '';

  postPatch = ''
    # See: https://github.com/gmr/rabbitpy/issues/118
    substituteInPlace setup.py \
      --replace 'pamqp>=1.6.1,<2.0' 'pamqp'
  '';

  meta = with stdenv.lib; {
    description = "A pure python, thread-safe, minimalistic and pythonic RabbitMQ client library";
    homepage = "https://pypi.python.org/pypi/rabbitpy";
    license = licenses.bsd3;
  };

}

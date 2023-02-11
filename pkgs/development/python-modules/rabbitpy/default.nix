{ lib
, buildPythonPackage
, fetchFromGitHub
, mock
, nose
, pamqp
}:

buildPythonPackage rec {
  version = "2.0.1";
  pname = "rabbitpy";

  # No tests in the pypi tarball, so we directly fetch from git
  src = fetchFromGitHub {
    owner = "gmr";
    repo = pname;
    rev = version;
    sha256 = "0m5z3i3d5adrz1wh6y35xjlls3cq6p4y9p1mzghw3k7hdvg26cck";
  };

  propagatedBuildInputs = [ pamqp ];
  nativeCheckInputs = [ mock nose ];

  checkPhase = ''
    runHook preCheck
    rm tests/integration_tests.py # Impure tests requiring network
    nosetests tests
    runHook postCheck
  '';

  postPatch = ''
    # See: https://github.com/gmr/rabbitpy/issues/118
    substituteInPlace setup.py \
      --replace 'pamqp>=2,<3' 'pamqp'
  '';

  meta = with lib; {
    description = "A pure python, thread-safe, minimalistic and pythonic RabbitMQ client library";
    homepage = "https://pypi.python.org/pypi/rabbitpy";
    license = licenses.bsd3;

    # broken by pamqp==3, tracked in
    # https://github.com/gmr/rabbitpy/issues/125
    broken = true;
  };

}

{ lib
, buildPythonPackage
, fetchPypi
, attrs
, botocore
, click
, enum-compat
, jmespath
, pip
, setuptools
, six
, typing
, wheel
, watchdog
, pytest
, hypothesis
, mock
}:

buildPythonPackage rec {
  pname = "chalice";
  version = "1.12.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f8f929f26df77285a202fb93174400230f8912c5b9c1fb061c7836a78413e325";
  };

  checkInputs = [ watchdog pytest hypothesis mock ];
  propagatedBuildInputs = [
    attrs
    botocore
    click
    enum-compat
    jmespath
    pip
    setuptools
    six
    wheel
    typing
  ];

  # conftest.py not included with pypi release
  doCheck = false;

  postPatch = ''
    substituteInPlace setup.py \
      --replace 'pip>=9,<=18.1' 'pip' \
      --replace 'typing==3.6.4' 'typing' \
      --replace 'attrs==17.4.0' 'attrs' \
      --replace 'click>=6.6,<7.0' 'click'
  '';

  checkPhase = ''
    pytest tests
  '';

  meta = with lib; {
    description = "Python Serverless Microframework for AWS";
    homepage = https://github.com/aws/chalice;
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}

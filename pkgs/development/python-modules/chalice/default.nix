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
  version = "1.13.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "07xzpbz7znr853xm6p27lkrcgdib3ym5dlwys0n4zvkjm5x7jn2a";
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
    sed -i setup.py -e "/pip>=/c\'pip',"
    substituteInPlace setup.py \
      --replace 'pip>=9,<=19.4' 'pip' \
      --replace 'typing==3.6.4' 'typing' \
      --replace 'attrs==17.4.0' 'attrs' \
      --replace 'click>=6.6,<7.0' 'click'
  '';

  checkPhase = ''
    pytest tests
  '';

  meta = with lib; {
    description = "Python Serverless Microframework for AWS";
    homepage = "https://github.com/aws/chalice";
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}

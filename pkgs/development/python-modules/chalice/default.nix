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
  version = "1.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "98a1237bf77f18761d8f964cb3c3b794e2d377a261b5e1640268608ec94336fa";
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

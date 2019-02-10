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
, pythonOlder
, watchdog
, pytest
, hypothesis
, mock
}:

buildPythonPackage rec {
  pname = "chalice";
  version = "1.6.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "96c22f95ccc91ed3e79cc4a9a88bf27f95a13a2caf5a55137ab081d371258f0f";
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

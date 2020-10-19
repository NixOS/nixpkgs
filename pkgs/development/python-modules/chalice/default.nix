{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, attrs
, botocore
, click
, enum-compat
, hypothesis
, jmespath
, mock
, mypy-extensions
, pip
, pytest
, pyyaml
, setuptools
, six
, typing
, watchdog
, wheel
}:

buildPythonPackage rec {
  pname = "chalice";
  version = "1.21.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "562218c5d257607fba3440e0a1d09bdac81a11536c432ad2af1e2d46f1735df4";
  };

  checkInputs = [ watchdog pytest hypothesis mock ];
  propagatedBuildInputs = [
    attrs
    botocore
    click
    enum-compat
    jmespath
    mypy-extensions
    pip
    pyyaml
    setuptools
    six
    wheel
  ] ++ lib.optionals (pythonOlder "3.5") [
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

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
  version = "1.21.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "73149f6a71aa1310f3d000110a915164a72f1d2dc7cd4d37d18a952b0e0c78ac";
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
      --replace 'typing==3.6.4' 'typing' \
      --replace 'attrs>=19.3.0,<20.3.0' 'attrs'
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

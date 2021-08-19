{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, attrs
, botocore
, click
, enum-compat
, hypothesis
, inquirer
, jmespath
, mock
, mypy-extensions
, pip
, pytest
, pyyaml
, setuptools
, six
, typing ? null
, watchdog
, wheel
}:

buildPythonPackage rec {
  pname = "chalice";
  version = "1.24.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e4faf2247291407481f7daa8cdb63120d3ea9f454332f3a74eefa33a307ef0e5";
  };

  checkInputs = [ watchdog pytest hypothesis mock ];
  propagatedBuildInputs = [
    attrs
    botocore
    click
    enum-compat
    inquirer
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
      --replace 'typing==3.6.4' 'typing'
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

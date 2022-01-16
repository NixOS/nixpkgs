{ lib
, buildPythonPackage
, cryptography
, fetchPypi
, pyopenssl
, pytestCheckHook
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "josepy";
  version = "1.12.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "267004a64f08c016cd54b7aaf7c323fa3ef3679fb62f4b086cd56448d0fecb25";
  };

  propagatedBuildInputs = [
    pyopenssl
    cryptography
    setuptools
  ];

  checkInputs = [
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace pytest.ini \
      --replace " --flake8 --cov-report xml --cov-report=term-missing --cov=josepy --cov-config .coveragerc" ""
    sed -i '/flake8-ignore/d' pytest.ini
  '';

  pythonImportsCheck = [
    "josepy"
  ];

  meta = with lib; {
    description = "JOSE protocol implementation in Python";
    homepage = "https://github.com/jezdez/josepy";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}

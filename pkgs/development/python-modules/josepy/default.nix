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
  version = "1.13.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-iTHa84+KTIUnSg6LfLJa3f2NHyj5+4++0FPdUa7HXck=";
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

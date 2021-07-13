{ lib
, fetchPypi
, buildPythonPackage
, cryptography
, pyopenssl
, setuptools
, mock
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "josepy";
  version = "1.8.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a5a182eb499665d99e7ec54bb3fe389f9cbc483d429c9651f20384ba29564269";
  };

  postPatch = ''
    # remove coverage flags
    sed -i '/addopts/d' pytest.ini
    sed -i '/flake8-ignore/d' pytest.ini
  '';

  propagatedBuildInputs = [
    pyopenssl
    cryptography
    setuptools
  ];

  checkInputs = [
    mock
    pytestCheckHook
  ];

  meta = with lib; {
    description = "JOSE protocol implementation in Python";
    homepage = "https://github.com/jezdez/josepy";
    license = licenses.asl20;
    maintainers = with maintainers; [  ];
  };
}


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
  version = "1.12.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "267004a64f08c016cd54b7aaf7c323fa3ef3679fb62f4b086cd56448d0fecb25";
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


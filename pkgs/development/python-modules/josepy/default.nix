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
  version = "1.10.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e9bcaf605411cadaec04841ae2d5f77ebb178b7b6df7c9aed1d97399ac18685b";
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


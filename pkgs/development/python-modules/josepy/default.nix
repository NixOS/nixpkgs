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
  version = "1.9.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "51cce8d97ced0556aae0ce3161b26d5f0f54bc42c749d3c606edc6d97d9802dc";
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


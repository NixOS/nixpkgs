{ lib, fetchPypi, buildPythonPackage
# buildInputs
, six
, setuptools
, pyopenssl
, cryptography
, mock
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "josepy";
  version = "1.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d265414fa16d7a8b7a1d1833b4ebb19a22bd0deae5d44413cf9040fd8491d85a";
  };

  postPatch = ''
    # remove coverage flags
    sed -i '/addopts/d' pytest.ini
  '';

  propagatedBuildInputs = [
    pyopenssl
    cryptography
    six
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


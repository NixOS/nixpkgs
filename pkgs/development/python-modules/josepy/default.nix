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
  version = "1.11.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "40ef59f2f537ec01bafe698dad66281f6ccf4642f747411647db403ab8fa9a2d";
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


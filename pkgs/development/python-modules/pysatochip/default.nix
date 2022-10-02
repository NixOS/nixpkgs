{ lib
, buildPythonPackage
, fetchPypi
, certifi
, cryptography
, ecdsa
, pyaes
, pyopenssl
, pyscard
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pysatochip";
  version = "0.14.2";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-+Z3D6ITZouhLbEotvJ9MDfg6QOhjGVKrLi1QL1kOdkE=";
  };

  postPatch = ''
    substituteInPlace requirements.txt \
      --replace "cryptography==3.3.2" "cryptography" \
      --replace "ecdsa==0.15" "ecdsa" \
      --replace "pyopenssl==20.0.0" "pyopenssl"
  '';

  propagatedBuildInputs = [ cryptography ecdsa pyaes pyopenssl pyscard ];

  checkInputs = [ certifi ];

  pythonImportsCheck = [ "pysatochip" ];

  meta = with lib; {
    description = "Simple python library to communicate with a Satochip hardware wallet";
    homepage = "https://github.com/Toporin/pysatochip";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ oxalica ];
  };
}

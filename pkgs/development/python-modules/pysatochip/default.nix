{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  certifi,
  cryptography,
  ecdsa,
  pyaes,
  pyopenssl,
  pyscard,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pysatochip";
  version = "0.15.1";
  format = "setuptools";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "toporin";
    repo = "pysatochip";
    rev = "v${version}";
    hash = "sha256-7wA9erk2OA1FyNSzOSWJzjyp9QeYq6C+YA8B0Dk2iQE=";
  };

  propagatedBuildInputs = [
    cryptography
    ecdsa
    pyaes
    pyopenssl
    pyscard
  ];

  nativeCheckInputs = [ certifi ];

  pythonImportsCheck = [ "pysatochip" ];

  meta = with lib; {
    description = "Simple python library to communicate with a Satochip hardware wallet";
    homepage = "https://github.com/Toporin/pysatochip";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ oxalica ];
  };
}

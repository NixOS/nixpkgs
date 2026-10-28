{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  certifi,
  cryptography,
  pyaes,
  pyopenssl,
  pyscard,
}:

buildPythonPackage rec {
  pname = "pysatochip";
  version = "0.18.7";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "toporin";
    repo = "pysatochip";
    tag = "v${version}";
    hash = "sha256-J4VGdeC+IowqWnCP8JFWGU8yPEaYCzfVn6F025/mwKY=";
  };

  propagatedBuildInputs = [
    cryptography
    pyaes
    pyopenssl
    pyscard
  ];

  nativeCheckInputs = [ certifi ];

  pythonImportsCheck = [ "pysatochip" ];

  meta = {
    description = "Simple python library to communicate with a Satochip hardware wallet";
    homepage = "https://github.com/Toporin/pysatochip";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [ oxalica ];
  };
}

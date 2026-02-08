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
}:

buildPythonPackage rec {
  pname = "pysatochip";
  version = "0.17.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "toporin";
    repo = "pysatochip";
    tag = "v${version}";
    hash = "sha256-9QenE9YpgrKwiN9kpS+KWdqFeba7AGXDneW5p+9/t1A=";
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

  meta = {
    description = "Simple python library to communicate with a Satochip hardware wallet";
    homepage = "https://github.com/Toporin/pysatochip";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [ oxalica ];
  };
}

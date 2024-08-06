{
  lib,
  fetchFromGitHub,
  stdenv,
  setuptools,
  colorama,
  six,
  buildPythonPackage,
}:

buildPythonPackage rec {
  pname = "reprint";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "Yinzo";
    repo = "reprint";
    rev = "${version}";
    hash = "sha256-99FC12LcvvRRwNAxDSvWo9vRYmieL0JHSaCJqO/UGEs=";
  };
  doCheck = false;

  build-system = [ setuptools ];

  dependencies = [
    colorama
    six
  ];


  pythonImportsCheck = [ "reprint" ];


  meta = {
    description = "Module for binding variables and refreshing multi-line output in terminal";
    homepage = "https://github.com/Yinzo/reprint";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jasonodoom ];
  };
}

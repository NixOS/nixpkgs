{ lib, buildPythonPackage, fetchPypi, argparse-addons, humanfriendly, pyelftools }:

buildPythonPackage rec {
  pname = "bincopy";
  version = "17.11.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-rk7jYr9jUz7TUckoYkv74rr5D9fJLD3h7UFBH0XeleE=";
  };

  propagatedBuildInputs = [
    argparse-addons
    humanfriendly
    pyelftools
  ];

  pythonImportsCheck = [ "bincopy" ];

  meta = with lib; {
    description = "Mangling of various file formats that conveys binary information (Motorola S-Record, Intel HEX, TI-TXT, ELF and binary files)";
    homepage = "https://github.com/eerimoq/bincopy";
    license = licenses.mit;
    maintainers = with maintainers; [ frogamic sbruder ];
  };
}

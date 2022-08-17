{ lib, buildPythonPackage, fetchPypi, argparse-addons, humanfriendly, pyelftools }:

buildPythonPackage rec {
  pname = "bincopy";
  version = "17.10.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-d1l+kqyGkBvctfKRHxCpve/8mLa7nTfDwXzxgJznce4=";
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

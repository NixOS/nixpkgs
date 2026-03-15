{
  lib,
  buildPythonPackage,
  fetchPypi,
  argparse-addons,
  humanfriendly,
  pyelftools,
}:

buildPythonPackage rec {
  pname = "bincopy";
  version = "20.1.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-6UpJi5pKvnZwPDdyqtRm8VY7T8mAnaeWXxG8dwlAk7k=";
  };

  propagatedBuildInputs = [
    argparse-addons
    humanfriendly
    pyelftools
  ];

  pythonImportsCheck = [ "bincopy" ];

  meta = {
    description = "Mangling of various file formats that conveys binary information (Motorola S-Record, Intel HEX, TI-TXT, ELF and binary files)";
    mainProgram = "bincopy";
    homepage = "https://github.com/eerimoq/bincopy";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      frogamic
      sbruder
    ];
  };
}

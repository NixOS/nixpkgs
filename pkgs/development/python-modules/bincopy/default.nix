{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  argparse-addons,
  humanfriendly,
  pyelftools,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "bincopy";
  version = "20.1.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-2KToy4Ltr7vjZ0FTN9GSbH2MRVYX5DvUsUVlN3K5uWU=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    argparse-addons
    humanfriendly
    pyelftools
  ];

  pythonImportsCheck = [ "bincopy" ];

  meta = with lib; {
    description = "Mangling of various file formats that conveys binary information (Motorola S-Record, Intel HEX, TI-TXT, ELF and binary files)";
    mainProgram = "bincopy";
    homepage = "https://github.com/eerimoq/bincopy";
    license = licenses.mit;
    maintainers = with maintainers; [
      frogamic
      sbruder
    ];
  };
}

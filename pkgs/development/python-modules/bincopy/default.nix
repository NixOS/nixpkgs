{
  lib,
  buildPythonPackage,
  fetchPypi,
  argparse-addons,
  humanfriendly,
  pyelftools,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "bincopy";
  version = "20.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-FM+0z5cie/Kx9bhWI99MdnrSGa/cn+BzLdLP3/RGr98=";
  };

  propagatedBuildInputs = [
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

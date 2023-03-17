{ lib, buildPythonPackage, fetchPypi, argparse-addons, humanfriendly, pyelftools }:

buildPythonPackage rec {
  pname = "bincopy";
  version = "17.14.5";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-X03nw3o9t63PPtxIM6Ij8zVtm/CL5y7G5DHJ8KzSnxg=";
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

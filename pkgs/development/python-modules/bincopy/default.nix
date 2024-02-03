{ lib, buildPythonPackage, fetchPypi, argparse-addons, humanfriendly, pyelftools }:

buildPythonPackage rec {
  pname = "bincopy";
  version = "19.1.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-aDVkrTBEhrTP1Oc/kiE9ZsJ+8fDGXcb2+FSMQP0X0lY=";
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

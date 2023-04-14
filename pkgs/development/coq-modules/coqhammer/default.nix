{ lib, mkCoqDerivation, coqhammer-tactics }:

mkCoqDerivation {
  pname = "coqhammer";
  opam-name = "coq-hammer";
  owner = "lukaszcz";

  inherit (coqhammer-tactics) src version;

  useDune = true;
  mlPlugin = true;

  buildInputs = [
    coqhammer-tactics
  ];

  propagatedBuildInputs = [
    coqhammer-tactics
  ];

  meta = with lib; {
    homepage = "http://cl-informatik.uibk.ac.at/cek/coqhammer/";
    description = "General-purpose automated reasoning hammer tool for Coq";
    longDescription = ''
      A general-purpose automated reasoning hammer tool for Coq that combines
      learning from previous proofs with the translation of problems to the
      logics of automated systems and the reconstruction of successfully found proofs.
      '';
    license = licenses.lgpl21;
    maintainers = with maintainers; [ alizter vbgl ];
  };
}

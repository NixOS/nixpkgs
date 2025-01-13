{
  lib,
  fetchFromGitHub,
  ppx_deriving,
  ppxlib,
  buildDunePackage,
  ounit,
}:

buildDunePackage rec {
  pname = "lens";
  version = "1.2.5";

  duneVersion = "3";

  src = fetchFromGitHub {
    owner = "pdonadeo";
    repo = "ocaml-lens";
    rev = "v${version}";
    sha256 = "1k23n7pa945fk6nbaq6nlkag5kg97wsw045ghz4gqp8b9i2im3vn";
  };

  minimalOCamlVersion = "4.10";
  buildInputs = [
    ppx_deriving
    ppxlib
  ];

  doCheck = true;
  checkInputs = [ ounit ];

  meta = with lib; {
    homepage = "https://github.com/pdonadeo/ocaml-lens";
    description = "Functional lenses";
    license = licenses.bsd3;
    maintainers = with maintainers; [
      kazcw
    ];
  };
}

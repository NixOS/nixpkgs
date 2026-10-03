{
  lib,
  fetchFromGitHub,
  ppx_deriving,
  ppxlib,
  buildDunePackage,
  ounit,
}:

buildDunePackage (finalAttrs: {
  pname = "lens";
  version = "1.2.5";

  duneVersion = "3";

  src = fetchFromGitHub {
    owner = "pdonadeo";
    repo = "ocaml-lens";
    rev = "v${finalAttrs.version}";
    hash = "sha256-do8aRUwLXfzIh68QwDU/6c3y1KTWYLWsma6QpO6xQ8w=";
  };

  minimalOCamlVersion = "4.10";
  buildInputs = [
    ppx_deriving
    ppxlib
  ];

  doCheck = true;
  checkInputs = [ ounit ];

  meta = {
    homepage = "https://github.com/pdonadeo/ocaml-lens";
    description = "Functional lenses";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      kazcw
    ];
  };
})

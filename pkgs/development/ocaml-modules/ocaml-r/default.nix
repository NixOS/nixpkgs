{ lib, fetchFromGitHub, fetchpatch, buildDunePackage, pkg-config, dune-configurator, stdio, R
, alcotest
}:

buildDunePackage rec {
  pname = "ocaml-r";
  version = "0.6.0";

  duneVersion = "3";

  minimalOCamlVersion = "4.08";

  src = fetchFromGitHub {
    owner = "pveber";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-jPyVMxjeh9+xu0dD1gelAxcOhxouKczyvzVoKZ5oSrs=";
  };

  # Finds R and Rmathlib separatley
  patches = [
    (fetchpatch {
      url = "https://github.com/pveber/ocaml-r/commit/aa96dc5.patch";
      sha256 = "sha256-xW33W2ciesyUkDKEH08yfOXv0wP0V6X80or2/n2Nrb4=";
    })
  ];

  nativeBuildInputs = [ pkg-config R ];
  buildInputs = [ dune-configurator stdio R ];

  doCheck = true;
  checkInputs = [ alcotest ];

  meta = {
    description = "OCaml bindings for the R interpreter";
    inherit (src.meta) homepage;
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.bcdarwin ];
  };

}

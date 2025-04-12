{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  ocaml,
  cppo,
}:

buildDunePackage rec {
  version = "1.2";
  pname = "ocplib-endian";

  src = fetchFromGitHub {
    owner = "OCamlPro";
    repo = "ocplib-endian";
    rev = version;
    sha256 = "sha256-THTlhOfXAPaqTt1qBkht+D67bw6M175QLvXoUMgjks4=";
  };

  postPatch = lib.optionalString (lib.versionAtLeast ocaml.version "5.0") ''
    substituteInPlace src/dune \
      --replace "(libraries bytes)" "" \
      --replace "libraries ocplib_endian bigarray bytes" "libraries ocplib_endian"
  '';

  minimalOCamlVersion = "4.03";

  nativeBuildInputs = [ cppo ];

  meta = with lib; {
    description = "Optimised functions to read and write int16/32/64";
    homepage = "https://github.com/OCamlPro/ocplib-endian";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ vbgl ];
  };
}

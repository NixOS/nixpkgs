{ lib, buildDunePackage, fetchurl }:

buildDunePackage rec {
  pname = "owl-base";
  version = "1.0.0";

  useDune2 = true;

  src = fetchurl {
    url = "https://github.com/owlbarn/owl/releases/download/${version}/owl-${version}.tbz";
    sha256 = "1gny4351ws2r7dp53nampfyh39l0z6qqvxj5v3d05mpdi2aa06yr";
  };

  minimumOCamlVersion = "4.10";

  meta = with lib; {
    description = "Numerical computing library for Ocaml";
    homepage = "https://ocaml.xyz";
    changelog = "https://github.com/owlbarn/owl/releases";
    platforms = platforms.x86_64;
    maintainers = [ maintainers.bcdarwin ];
    license = licenses.mit;
  };
}

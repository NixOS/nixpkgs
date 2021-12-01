{ lib, buildDunePackage, fetchurl }:

buildDunePackage rec {
  pname = "owl-base";
  version = "1.0.1";

  useDune2 = true;

  src = fetchurl {
    url = "https://github.com/owlbarn/owl/releases/download/${version}/owl-${version}.tbz";
    sha256 = "72ca9f6edd302fdfa16c7559cedac7ac2c885466a367e17ea1ea8807b2dd13ef";
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

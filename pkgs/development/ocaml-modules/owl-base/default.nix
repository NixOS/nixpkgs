{ lib, buildDunePackage, fetchurl }:

buildDunePackage rec {
  pname = "owl-base";
  version = "0.10.0";

  useDune2 = true;

  src = fetchurl {
    url = "https://github.com/owlbarn/owl/releases/download/${version}/owl-${version}.tbz";
    sha256 = "148ny2cdzga1l36kcibvlz5xlyi5zvkywifxaqn8lf79n1swmlzf";
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

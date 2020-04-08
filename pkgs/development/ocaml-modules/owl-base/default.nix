{ stdenv, buildDunePackage, fetchFromGitHub, stdlib-shims }:

buildDunePackage rec {
  pname = "owl-base";
  version = "0.8.0";

  useDune2 = true;

  src = fetchFromGitHub {
    owner  = "owlbarn";
    repo   = "owl";
    rev    = version;
    sha256 = "1j3xmr4izfznmv8lbn8vkx9c77py2xr6fqyn6ypjlf5k9b8g4mmw";
  };

  propagatedBuildInputs = [ stdlib-shims ];

  minimumOCamlVersion = "4.06";

  meta = with stdenv.lib; {
    description = "Numerical computing library for Ocaml";
    homepage = "https://ocaml.xyz";
    platforms = platforms.x86_64;
    maintainers = [ maintainers.bcdarwin ];
    license = licenses.mit;
  };
}

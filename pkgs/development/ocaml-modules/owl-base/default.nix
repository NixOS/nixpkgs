{ stdenv, buildDunePackage, fetchFromGitHub, stdlib-shims }:

buildDunePackage rec {
  pname = "owl-base";
  version = "0.7.2";

  src = fetchFromGitHub {
    owner  = "owlbarn";
    repo   = "owl";
    rev    = version;
    sha256 = "1a2lbhywrb3bmm4k48wwbp6iszpd3aj1f23v10i78cbqm5slk6dj";
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

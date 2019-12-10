{ stdenv, buildDunePackage, fetchFromGitHub, stdlib-shims }:

buildDunePackage rec {
  pname = "owl-base";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner  = "owlbarn";
    repo   = "owl";
    rev    = version;
    sha256 = "1v4jfn3w18zq188f9gskx9ffja3xx59j2mgrw6azp8lsbqixg5xk";
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

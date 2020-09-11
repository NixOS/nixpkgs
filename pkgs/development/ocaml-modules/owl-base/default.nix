{ stdenv, buildDunePackage, fetchFromGitHub, stdlib-shims }:

buildDunePackage rec {
  pname = "owl-base";
  version = "0.9.0";

  useDune2 = true;

  src = fetchFromGitHub {
    owner = "owlbarn";
    repo = "owl";
    rev  = version;
    sha256 = "0xxchsymmdbwszs6barqq8x4vqz5hbap64yxq82c2la9sdxgk0vv";
  };

  propagatedBuildInputs = [ stdlib-shims ];

  minimumOCamlVersion = "4.10";

  meta = with stdenv.lib; {
    description = "Numerical computing library for Ocaml";
    homepage = "https://ocaml.xyz";
    changelog = "https://github.com/owlbarn/owl/releases";
    platforms = platforms.x86_64;
    maintainers = [ maintainers.bcdarwin ];
    license = licenses.mit;
  };
}

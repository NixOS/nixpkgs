{ lib, fetchFromGitHub, buildDunePackage }:

buildDunePackage rec {
  pname = "bigstring";
  version = "0.3";

  useDune2 = true;

  minimumOCamlVersion = "4.03";

  src = fetchFromGitHub {
    owner = "c-cube";
    repo = "ocaml-bigstring";
    rev = version;
    sha256 = "0bkxwdcswy80f6rmx5wjza92xzq4rdqsb4a9fm8aav8bdqx021n8";
  };

  # Circular dependency with bigstring-unix
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/c-cube/ocaml-bigstring";
    description = "Bigstring built on top of bigarrays, and convenient functions";
    license = licenses.bsd2;
    maintainers = [ maintainers.alexfmpe ];
  };
}

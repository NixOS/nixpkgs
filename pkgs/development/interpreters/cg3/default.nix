{ lib
, stdenv
, fetchFromGitHub
, runCommand
, dieHook
, cmake
, icu
, boost
}:

let cg3 = stdenv.mkDerivation rec {
  pname = "cg3";
  version = "1.3.7";

  src = fetchFromGitHub {
    owner = "GrammarSoft";
    repo = "${pname}";
    rev = "v${version}";
    sha256 = "Ena3dGoZsXOIY6mbvnfI0H7QqRifoxWIBKQrK3yQSmY=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    icu
    boost
  ];

  doCheck = true;

  passthru.tests.minimal = runCommand "${pname}-test" {
      buildInputs = [
        cg3
        dieHook
      ];
    } ''
      echo 'DELIMITERS = "."; ADD (tag) (*);' >grammar.cg3
      printf '"<a>"\n\t"a" tag\n\n' >want.txt
      printf '"<a>"\n\t"a"\n\n' | vislcg3 -g grammar.cg3 >got.txt
      diff -s want.txt got.txt || die "Grammar application did not produce expected parse"
      touch $out
    '';


  # TODO, consider optionals:
  # - Enable tcmalloc unless darwin?
  # - Enable python bindings?

  meta = with lib; {
    homepage = "https://github.com/GrammarSoft/cg3";
    description = "Constraint Grammar interpreter, compiler and applicator vislcg3";
    maintainers = with maintainers; [ unhammer ];
    license = licenses.gpl3Plus;
    platforms = platforms.all;
  };
};

in
  cg3

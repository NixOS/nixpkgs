{
  lib,
  stdenv,
  fetchFromGitHub,
  ocaml,
  findlib,
  opaline,
}:

stdenv.mkDerivation rec {
  pname = "afl-persistent";
  version = "1.3";
  name = "ocaml${ocaml.version}-${pname}-${version}";

  src = fetchFromGitHub {
    owner = "stedolan";
    repo = "ocaml-${pname}";
    rev = "v${version}";
    sha256 = "06yyds2vcwlfr2nd3gvyrazlijjcrd1abnvkfpkaadgwdw3qam1i";
  };

  strictDeps = true;

  nativeBuildInputs = [
    ocaml
    findlib
  ];

  # don't run tests in buildPhase
  # don't overwrite test binary
  postPatch = ''
    sed -i 's/ && \.\/test$//' build.sh
    sed -i '/^ocamlopt.*test.ml -o test$/ s/$/2/' build.sh
    patchShebangs build.sh
  '';

  buildPhase = "./build.sh";
  installPhase = ''
    ${opaline}/bin/opaline -prefix $out -libdir $out/lib/ocaml/${ocaml.version}/site-lib/ ${pname}.install
  '';

  doCheck = true;
  checkPhase = "./_build/test && ./_build/test2";

  meta = with lib; {
    homepage = "https://github.com/stedolan/ocaml-afl-persistent";
    description = "persistent-mode afl-fuzz for ocaml";
    license = licenses.mit;
    maintainers = [ maintainers.sternenseemann ];
  };
}

{ stdenv, fetchgit, ocaml, findlib, menhir, which }:

let inherit (stdenv.lib) getVersion versionAtLeast; in

assert versionAtLeast (getVersion ocaml) "3.12";

stdenv.mkDerivation {

  name = "eff-20140928";

  src = fetchgit {
    url = "https://github.com/matijapretnar/eff.git";
    rev = "90f884a790fddddb51d4d1d3b7c2edf1e8aabb64";
    sha256 = "28e389b35e6959072c245c2e79fe305885b1b2d44ff540a02a097e09e9f9698f";
  };

  buildInputs = [ ocaml findlib menhir which ];

  doCheck = true;
  checkTarget = "test";

  meta = with stdenv.lib; {
    homepage = "http://www.eff-lang.org";
    description = "A functional programming language based on algebraic effects and their handlers";
    longDescription = ''
      Eff is a functional language with handlers of not only exceptions,
      but also of other computational effects such as state or I/O. With
      handlers, you can simply implement transactions, redirections,
      backtracking, multi-threading, and much more...
    '';
    license = licenses.bsd2;
    platforms = ocaml.meta.platforms or [];
    maintainers = [ maintainers.jirkamarsik ];
  };
}

{ stdenv, fetchgit, coq, haskellPackages, which, ott
}:

stdenv.mkDerivation rec {
  name = "metalib-${coq.coq-version}-${version}";
  version = "20170713";

  src = fetchgit {
    url = https://github.com/plclub/metalib.git;
    rev = "44e40aa082452dd333fc1ca2d2cc55311519bd52";
    sha256 = "1pra0nvx69q8d4bvpcvh9ngic1cy6z1chi03x56nisfqnc61b6y9";
  };

  # The 'lngen' command-line utility is built from Haskell sources
  lngen = with haskellPackages; mkDerivation {
    pname = "lngen";
    version = "0.0.1";
    src = fetchgit {
      url = https://github.com/plclub/lngen;
      rev = "ea73ad315de33afd25f87ca738c71f358f1cd51c";
      sha256 = "1a0sj8n3lmsl1wlnqfy176k9lb9s8rl422bvg3ihl2i70ql8wisd";
    };
    isLibrary = true;
    isExecutable = true;
    libraryHaskellDepends = [ base containers mtl parsec syb ];
    executableHaskellDepends = [ base ];
    homepage = https://github.com/plclub/lngen;
    description = "Tool for generating Locally Nameless definitions and proofs in Coq, working together with Ott";
    license = stdenv.lib.licenses.mit;
  };

  buildInputs = with coq.ocamlPackages; [ ocaml camlp5 which coq lngen ott findlib ];
  propagatedBuildInputs = [ coq ];

  enableParallelBuilding = true;

  buildPhase = ''
    (cd Metalib; make)
  '';

  installPhase = ''
    (cd Metalib; make -f CoqSrc.mk DSTROOT=/ COQLIB=$out/lib/coq/${coq.coq-version}/ install)
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/plclub/metalib;
    license = licenses.mit;
    maintainers = [ maintainers.jwiegley ];
    platforms = coq.meta.platforms;
  };

  passthru = {
    compatibleCoqVersions = v: builtins.elem v [ "8.6" "8.7" "8.8" ];
  };

}

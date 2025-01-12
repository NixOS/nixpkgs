{
  lib,
  fetchFromGitHub,
  buildDunePackage,
}:

buildDunePackage rec {
  pname = "mparser";
  version = "1.3";
  useDune2 = true;

  src = fetchFromGitHub {
    owner = "murmour";
    repo = "mparser";
    rev = version;
    sha256 = "16j19v16r42gcsii6a337zrs5cxnf12ig0vaysxyr7sq5lplqhkx";
  };

  meta = {
    description = "Simple monadic parser combinator OCaml library";
    license = lib.licenses.lgpl21Plus;
    homepage = "https://github.com/murmour/mparser";
    maintainers = [ lib.maintainers.vbgl ];
  };
}

{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  result,
  trie,
}:

buildDunePackage rec {
  pname = "mew";
  version = "0.1.0";

  useDune2 = true;

  src = fetchFromGitHub {
    owner = "kandu";
    repo = pname;
    rev = version;
    sha256 = "0417xsghj92v3xa5q4dk4nzf2r4mylrx2fd18i7cg3nzja65nia2";
  };

  propagatedBuildInputs = [
    result
    trie
  ];

  meta = {
    inherit (src.meta) homepage;
    license = lib.licenses.mit;
    description = "Modal Editing Witch";
    maintainers = [ lib.maintainers.vbgl ];
  };

}

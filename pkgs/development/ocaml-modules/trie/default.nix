{
  lib,
  buildDunePackage,
  fetchFromGitHub,
}:

buildDunePackage rec {
  pname = "trie";
  version = "1.0.0";

  useDune2 = true;

  src = fetchFromGitHub {
    owner = "kandu";
    repo = pname;
    rev = version;
    sha256 = "0s7p9swjqjsqddylmgid6cv263ggq7pmb734z4k84yfcrgb6kg4g";
  };

  meta = with lib; {
    inherit (src.meta) homepage;
    license = licenses.mit;
    description = "Strict impure trie tree";
    maintainers = [ maintainers.vbgl ];
  };

}

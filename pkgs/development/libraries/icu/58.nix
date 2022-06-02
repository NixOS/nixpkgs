fetchurl:
let
  keywordFix = fetchurl {
    url = "http://bugs.icu-project.org/trac/changeset/39484?format=diff";
    name = "icu-changeset-39484.diff";
    sha256 = "0hxhpgydalyxacaaxlmaddc1sjwh65rsnpmg0j414mnblq74vmm8";
  };
in
import ./base.nix {
  version = "58.2";
  sha256 = "036shcb3f8bm1lynhlsb4kpjm9s9c2vdiir01vg216rs2l8482ib";
  patches = [ keywordFix ];
  patchFlags = [ "-p4" ];
}

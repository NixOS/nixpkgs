{ lib, buildDunePackage, fetchurl }:

buildDunePackage rec {
  pname = "atdgen-codec-runtime";
  version = "2.10.0";

  src = fetchurl {
    url = "https://github.com/ahrefs/atd/releases/download/${version}/atdts-${version}.tbz";
    sha256 = "sha256-d9J0CaTp2sQbnKLp6mCDbGwYAIsioVer7ftaLSSFCZg=";
  };

  meta = {
    description = "Runtime for atdgen generated bucklescript converters";
    homepage = "https://github.com/ahrefs/atd";
    maintainers = [ lib.maintainers.vbgl ];
    license = lib.licenses.mit;
  };
}

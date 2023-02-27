{ buildDunePackage
, lib
, fetchurl
}:

buildDunePackage rec {
  pname = "stdcompat";
  version = "19";

  src = fetchurl {
    url = "https://github.com/thierry-martinez/stdcompat/releases/download/v${version}/stdcompat-${version}.tar.gz";
    sha256 = "sha256-DKQGd4nnIN6SPls6hcA/2Jvc7ivYNpeMU6rYsVc1ClU=";
  };

  # Otherwise ./configure script will run and create files conflicting with dune.
  dontConfigure = true;

  meta = {
    homepage = "https://github.com/thierry-martinez/stdcompat";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.vbgl ];
  };
}

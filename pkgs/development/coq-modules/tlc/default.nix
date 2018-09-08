{ stdenv, fetchurl, coq }:

stdenv.mkDerivation rec {
  version = "20180316";
  name = "coq${coq.coq-version}-tlc-${version}";

  src = fetchurl {
    url = "http://tlc.gforge.inria.fr/releases/tlc-${version}.tar.gz";
    sha256 = "0y8h0x9dfn9dm60j1jkxr9i8lbfqd3ff626wrc9v49qxhi50szqq";
  };

  buildInputs = [ coq ];

  installFlags = "CONTRIB=$(out)/lib/coq/${coq.coq-version}/user-contrib";

  meta = {
    homepage = http://www.chargueraud.org/softs/tlc/;
    description = "A non-constructive library for Coq";
    license = stdenv.lib.licenses.free;
    maintainers = [ stdenv.lib.maintainers.vbgl ];
    inherit (coq.meta) platforms;
  };

  passthru = {
    compatibleCoqVersions = v: stdenv.lib.versionAtLeast v "8.6";
  };
}

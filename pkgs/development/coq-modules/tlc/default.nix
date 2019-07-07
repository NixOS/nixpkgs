{ stdenv, fetchurl, coq }:

stdenv.mkDerivation rec {
  version = "20181116";
  name = "coq${coq.coq-version}-tlc-${version}";

  src = fetchurl {
    url = "http://tlc.gforge.inria.fr/releases/tlc-${version}.tar.gz";
    sha256 = "0iv6f6zmrv2lhq3xq57ipmw856ahsql754776ymv5wjm88ld63nm";
  };

  buildInputs = [ coq ];

  installFlags = "CONTRIB=$(out)/lib/coq/${coq.coq-version}/user-contrib";

  meta = {
    homepage = "http://www.chargueraud.org/softs/tlc/";
    description = "A non-constructive library for Coq";
    license = stdenv.lib.licenses.free;
    maintainers = [ stdenv.lib.maintainers.vbgl ];
    inherit (coq.meta) platforms;
  };

  passthru = {
    compatibleCoqVersions = v: stdenv.lib.versionAtLeast v "8.6";
  };
}

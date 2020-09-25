{ stdenv, fetchurl, fetchFromGitHub, coq }:

let params =
  if stdenv.lib.versionAtLeast coq.coq-version "8.10"
  then rec {
    version = "20200328";
    src = fetchFromGitHub {
      owner = "charguer";
      repo = "tlc";
      rev = version;
      sha256 = "16vzild9gni8zhgb3qhmka47f8zagdh03k6nssif7drpim8233lx";
    };
  } else rec {
    version = "20181116";
    src = fetchurl {
      url = "http://tlc.gforge.inria.fr/releases/tlc-${version}.tar.gz";
      sha256 = "0iv6f6zmrv2lhq3xq57ipmw856ahsql754776ymv5wjm88ld63nm";
    };
  }
; in

stdenv.mkDerivation {
  inherit (params) version src;
  pname = "coq${coq.coq-version}-tlc";

  buildInputs = [ coq ];

  installFlags = [ "CONTRIB=$(out)/lib/coq/${coq.coq-version}/user-contrib" ];

  meta = {
    homepage = "http://www.chargueraud.org/softs/tlc/";
    description = "A non-constructive library for Coq";
    license = stdenv.lib.licenses.free;
    maintainers = [ stdenv.lib.maintainers.vbgl ];
    inherit (coq.meta) platforms;
  };

  passthru = {
    compatibleCoqVersions = stdenv.lib.flip builtins.elem [ "8.6" "8.7" "8.8" "8.9" "8.10" "8.11" "8.12" ];
  };
}

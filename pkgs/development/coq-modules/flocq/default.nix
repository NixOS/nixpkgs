{ stdenv, bash, which, autoconf, automake, fetchurl, coq }:

let params =
  if stdenv.lib.versionAtLeast coq.coq-version "8.7" then {
    version = "3.0.0";
    uid = "37477";
    sha256 = "1h05ji5cmyqyv2i1l83xgkm7vfvcnl8r1dzvbp5yncm1jr9kf6nn";
  } else {
    version = "2.6.1";
    uid = "37454";
    sha256 = "06msp1fwpqv6p98a3i1nnkj7ch9rcq3rm916yxq8dxf51lkghrin";
  }
; in

stdenv.mkDerivation rec {

  name = "coq${coq.coq-version}-flocq-${version}";
  inherit (params) version;

  src = fetchurl {
    url = "https://gforge.inria.fr/frs/download.php/file/${params.uid}/flocq-${version}.tar.gz";
    inherit (params) sha256;
  };

  nativeBuildInputs = [ bash which autoconf automake ];
  buildInputs = [ coq ] ++ (with coq.ocamlPackages; [
    ocaml camlp5
  ]);

  buildPhase = ''
    ${bash}/bin/bash autogen.sh
    ${bash}/bin/bash configure --libdir=$out/lib/coq/${coq.coq-version}/user-contrib/Flocq
    ./remake
  '';

  installPhase = ''
    ./remake install
  '';

  meta = with stdenv.lib; {
    homepage = http://flocq.gforge.inria.fr/;
    description = "A floating-point formalization for the Coq system";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ jwiegley ];
    platforms = coq.meta.platforms;
  };

  passthru = {
    compatibleCoqVersions = v: builtins.elem v [ "8.5" "8.6" "8.7" "8.8" ];
  };
}

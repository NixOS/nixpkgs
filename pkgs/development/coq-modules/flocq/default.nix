{ stdenv, bash, which, autoconf, automake, fetchzip, coq }:

let params =
  if stdenv.lib.versionAtLeast coq.coq-version "8.7" then {
    version = "3.2.0";
    sha256 = "15bi36x7zj0glsb3s2gwqd4wswhfzh36rbp7imbyff53a7nna95l";
  } else {
    version = "2.6.1";
    sha256 = "1y4czkfrd8p37vwv198nns4hz1brfv71na17pxsidwpxy7qnyfw1";
  }
; in

stdenv.mkDerivation rec {

  name = "coq${coq.coq-version}-flocq-${version}";
  inherit (params) version;

  src = fetchzip {
    url = "https://gitlab.inria.fr/flocq/flocq/-/archive/flocq-${version}.tar.gz";
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
    compatibleCoqVersions = v: builtins.elem v [ "8.5" "8.6" "8.7" "8.8" "8.9" "8.10" ];
  };
}

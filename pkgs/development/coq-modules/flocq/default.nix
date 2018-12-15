{stdenv, bash, which, autoconf, automake, fetchurl, coq}:

stdenv.mkDerivation rec {

  name = "coq${coq.coq-version}-flocq-${version}";
  version = "2.6.0";

  src = fetchurl {
    url = https://gforge.inria.fr/frs/download.php/file/37054/flocq-2.6.0.tar.gz;
    sha256 = "13fv150dcwnjrk00d7zj2c5x9jwmxgrq0ay440gkr730l8mvk3l3";
  };

  buildInputs = with coq.ocamlPackages; [ ocaml camlp5 bash which autoconf automake ];
  propagatedBuildInputs = [ coq ];

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

}

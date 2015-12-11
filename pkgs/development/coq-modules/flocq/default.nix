{stdenv, bash, which, autoconf, automake, fetchurl, coq}:

stdenv.mkDerivation rec {

  name = "coq-flocq-${coq.coq-version}-${version}";
  version = "2.5.0";

  src = fetchurl {
    url = https://gforge.inria.fr/frs/download.php/file/35091/flocq-2.5.0.tar.gz;
    sha256 = "0v3qiaz7vxfc5nk8rxwi39mik7hm7p5kb040q2pimb69qgfl6vml";
  };

  buildInputs = [ coq.ocaml coq.camlp5 bash which autoconf automake ];
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

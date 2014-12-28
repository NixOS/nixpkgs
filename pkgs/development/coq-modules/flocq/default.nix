{stdenv, bash, which, autoconf, automake, fetchurl, coq}:

stdenv.mkDerivation rec {

  name = "coq-flocq-${coq.coq-version}-${version}";
  version = "2.4.0";

  src = fetchurl {
    url = https://gforge.inria.fr/frs/download.php/file/33979/flocq-2.4.0.tar.gz;
    sha256 = "020x4nkkrvndkvp5zwb9vads8a2jh603khcwrm40yhqldgfd8zlv";
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
    description = "Flocq (Floats for Coq) is a floating-point formalization for the Coq system";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ jwiegley ];
    platforms = coq.meta.platforms;
  };

}

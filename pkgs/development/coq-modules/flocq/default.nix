{stdenv, bash, which, autoconf, automake, fetchurl, coq}:

stdenv.mkDerivation rec {

  name = "coq${coq.coq-version}-flocq-${version}";
  version = "2.5.2";

  src = fetchurl {
    url = https://gforge.inria.fr/frs/download.php/file/36199/flocq-2.5.2.tar.gz;
    sha256 = "0h5mlasirfzc0wwn2isg4kahk384n73145akkpinrxq5jsn5d22h";
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

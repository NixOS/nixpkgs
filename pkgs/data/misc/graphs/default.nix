{ stdenv
, fetchurl
}:

stdenv.mkDerivation rec {
  pname = "graphs";
  version = "20161026";

  src = fetchurl {
    url = "mirror://sageupstream/${pname}/${pname}-${version}.tar.bz2";
    sha256 = "0a2b5lly9nifphvknz88rrhfbbc8vqnlqcv19zdpfq8h8nnyjbb2";
  };

  installPhase = ''
    mkdir -p "$out/share/graphs"
    cp * "$out/share/graphs/"
  '';

  meta = with stdenv.lib; {
    description = "A database of graphs";
    license = licenses.gpl2;
    platforms = platforms.all;
    maintainers = with maintainers; [ timokau ];
  };
}

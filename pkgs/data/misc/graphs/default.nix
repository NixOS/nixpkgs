{ lib, stdenv
, fetchurl
}:

stdenv.mkDerivation rec {
  pname = "graphs";
  version = "20210214";

  src = fetchurl {
    url = "mirror://sageupstream/${pname}/${pname}-${version}.tar.bz2";
    sha256 = "sha256-ByN8DZhTYRUFw4n9e7klAMh0P1YxurtND0Xf2DMvN0E=";
  };

  installPhase = ''
    mkdir -p "$out/share/graphs"
    cp * "$out/share/graphs/"
  '';

  meta = with lib; {
    description = "A database of graphs";
    license = licenses.gpl2;
    platforms = platforms.all;
    maintainers = teams.sage.members;
  };
}

{ stdenv, fetchurl, boost }:

stdenv.mkDerivation rec {
  pname = "mdds";
  version = "1.4.3";

  src = fetchurl {
    url = "https://kohei.us/files/${pname}/src/${pname}-${version}.tar.bz2";
    sha256 = "10cw6irdm6d15nxnys2v5akp8yz52qijpcjvw0frwq7nz5d3vki5";
  };

  postInstall = ''
    mkdir -p "$out/lib/pkgconfig"
    cp "$out/share/pkgconfig/"* "$out/lib/pkgconfig"
  '';

  checkInputs = [ boost ];

  meta = with stdenv.lib; {
    inherit version;
    homepage = https://gitlab.com/mdds/mdds;
    description = "A collection of multi-dimensional data structure and indexing algorithm";
    platforms = platforms.all;
    license = licenses.mit;
  };
}

{ stdenv, fetchurl, boost }:

stdenv.mkDerivation rec {
  pname = "mdds";
  version = "1.5.0";

  src = fetchurl {
    url = "https://kohei.us/files/${pname}/src/${pname}-${version}.tar.bz2";
    sha256 = "03b8i43pw4m767mm0cnbi77x7qhpkzpi9b1f6dpp4cmyszmnsk8l";
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

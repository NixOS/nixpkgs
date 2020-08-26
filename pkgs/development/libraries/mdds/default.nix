{ stdenv, fetchurl, boost }:

stdenv.mkDerivation rec {
  pname = "mdds";
  version = "1.6.0";

  src = fetchurl {
    url = "https://kohei.us/files/${pname}/src/${pname}-${version}.tar.bz2";
    sha256 = "0zg0v9rfs92ff1gpnb06gzbxbnd9nqdar5fk8dnkmy0jpnf5qn7i";
  };

  postInstall = ''
    mkdir -p "$out/lib/pkgconfig"
    cp "$out/share/pkgconfig/"* "$out/lib/pkgconfig"
  '';

  checkInputs = [ boost ];

  meta = with stdenv.lib; {
    inherit version;
    homepage = "https://gitlab.com/mdds/mdds";
    description = "A collection of multi-dimensional data structure and indexing algorithm";
    platforms = platforms.all;
    license = licenses.mit;
  };
}

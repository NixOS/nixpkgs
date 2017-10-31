{ stdenv, fetchzip }:

let
  version = "0.130";
in fetchzip {
  name = "culmus-${version}";

  url = "mirror://sourceforge/culmus/culmus/${version}/culmus-${version}.tar.gz";

  postFetch = ''
    tar -xzvf $downloadedFile --strip-components=1
    mkdir -p $out/share/fonts/truetype
    cp -v *.ttf $out/share/fonts/truetype/
  '';

  sha256 = "0v5vm8j2bxnw2qn0640kyibn4h8ck8cidhx2pixi5xsayr0ij1n6";

  meta = {
    description = "Culmus Hebrew fonts";
    longDescription = "The Culmus project aims at providing the Hebrew-speaking GNU/Linux and Unix community with a basic collection of Hebrew fonts for X Windows.";
    platforms = stdenv.lib.platforms.all;
    license = stdenv.lib.licenses.gpl2;
    homepage = http://culmus.sourceforge.net/;
    downloadPage = http://culmus.sourceforge.net/download.html;
  };
}

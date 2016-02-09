{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  name = "ubuntu-font-family-0.83";
  buildInputs = [unzip];

  src = fetchurl {
    url = "http://font.ubuntu.com/download/${name}.zip";
    sha256 = "0hjvq2x758dx0sfwqhzflns0ns035qm7h6ygskbx1svzg517sva5";
  };

  installPhase =
    ''
      mkdir -p $out/share/fonts/ubuntu
      cp *.ttf $out/share/fonts/ubuntu
    '';

  meta = {
    description = "Ubuntu Font Family";
    longDescription = "The Ubuntu typeface has been specially
    created to complement the Ubuntu tone of voice. It has a
    contemporary style and contains characteristics unique to
    the Ubuntu brand that convey a precise, reliable and free attitude.";
    homepage = http://font.ubuntu.com/;
    license = stdenv.lib.licenses.free;
    platforms = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.antono ];
  };
}

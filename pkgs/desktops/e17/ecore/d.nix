{ stdenv, fetchurl, pkgconfig, eina, evas, xproto, libX11, libXext }:
stdenv.mkDerivation rec {
  name = "ecore-${version}";
  version = "1.0.1";
  src = fetchurl {
    url = "http://download.enlightenment.org/releases/${name}.tar.gz";
    sha256 = "1vi03zxnsdnrjv1rh5r3v0si0b20ikrfb8hf5374i2sqvi1g65j0";
  };
  buildInputs = [ pkgconfig eina evas xproto ];
  propagatedBuildInputs = [ libX11 libXext ];
  meta = {
    description = "";
    longDescription = ''
    '';
    homepage = http://enlightenment.org/;
    license = "BSD-style???";
  };
}

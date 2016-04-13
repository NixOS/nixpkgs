{ stdenv, fetchurl, ncurses, zlib }:

stdenv.mkDerivation rec {
  name = "libcaca-0.99.beta19";

  src = fetchurl {
    urls = [
      "http://fossies.org/linux/privat/${name}.tar.gz"
      "http://caca.zoy.org/files/libcaca/${name}.tar.gz"
    ];
    sha256 = "1x3j6yfyxl52adgnabycr0n38j9hx2j74la0hz0n8cnh9ry4d2qj";
  };

  outputs = [ "dev" "bin" "out" "man" ];

  configureFlags = "--disable-x11 --disable-imlib2 --disable-doc";

  propagatedBuildInputs = [ ncurses zlib ];

  postInstall = ''
    mkdir -p $dev/bin
    mv $bin/bin/caca-config $dev/bin/caca-config
  '';

  meta = {
    homepage = http://libcaca.zoy.org/;
    description = "A graphics library that outputs text instead of pixels";
    license = stdenv.lib.licenses.wtfpl;
  };
}

{ stdenv, fetchurl, pkgconfig, guile, texinfo }:

stdenv.mkDerivation {
  name = "guile-xcb-1.3";

  meta = with stdenv.lib; {
    description = "XCB bindings for Guile";
    homepage    = "http://www.markwitmer.com/guile-xcb/guile-xcb.html";
    license     = licenses.gpl3Plus;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ iyzsong ];
  };

  src = fetchurl {
    name = "guile-xcb-1.3.tar.gz";
    sha256 = "1gna9h3536s880p4bd9n2jyh2a8igwya6x7v3vfx19f4rppmai60";

    urls = [
     "http://www.markwitmer.com/dist/guile-xcb-1.3.tar.gz"
     "https://github.com/mwitmer/guile-xcb/archive/1.3.tar.gz"
    ];
  };

  buildInputs = [ pkgconfig guile texinfo ];

  preConfigure = ''
    configureFlags="
      --with-guile-site-dir=$out/share/guile/site
      --with-guile-site-ccache-dir=$out/share/guile/site
    ";
  '';
}

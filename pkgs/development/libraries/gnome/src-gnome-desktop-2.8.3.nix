{stdenv, fetchurl} : {

  gnomeicontheme = {
    name = "gnome-icon-theme-2.8.0";
    src = fetchurl {
      url = ftp://ftp.gnome.org/Public/gnome/desktop/2.8/2.8.3/sources/gnome-icon-theme-2.8.0.tar.bz2;
      md5 = "7be016337c44c024fb22f7b94b689d7b";
    };
  };

  gnomekeyring = {
    name = "gnome-keyring-0.4.1";
    src = fetchurl {
      url = ftp://ftp.gnome.org/Public/gnome/desktop/2.8/2.8.3/sources/gnome-keyring-0.4.1.tar.bz2;
      md5 = "031901a50273cc5a39b1305924613a1b";
    };
  };

  gtkhtml = {
    name = "gtkhtml-3.2.5";
    src = fetchurl {
      url = ftp://ftp.gnome.org/Public/gnome/desktop/2.8/2.8.3/sources/gtkhtml-3.2.5.tar.bz2;
      md5 = "86e1ce32fed536bce5b2d6e8d41b0c65";
    };
  };

  libgtkhtml = {
    name = "libgtkhtml-2.6.3";
    src = fetchurl {
      url = ftp://ftp.gnome.org/Public/gnome/desktop/2.8/2.8.3/sources/libgtkhtml-2.6.3.tar.bz2;
      md5 = "c77789241d725e189ffc0391eda94361";
    };
  };

  gtksourceview = {
    name = "gtksourceview-1.1.1";
    src = fetchurl {
      url = ftp://ftp.gnome.org/Public/gnome/desktop/2.8/2.8.3/sources/gtksourceview-1.1.1.tar.bz2;
      md5 = "2e59c8748594181d4bf452320c8c3b5c";
    };
  };
}
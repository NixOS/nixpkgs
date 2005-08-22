# this file can (and should) be generated from an FTP listing

{stdenv, fetchurl} : {
  gconf = {
    name = "GConf-2.8.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/GConf-2.8.1.tar.bz2;
      md5 = "b1173cbe33404bcbcc15710ce2a28f67";
    };
  };

  ORBit2 = {
    name = "ORBit2-2.12.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/ORBit2-2.12.1.tar.bz2;
      md5 = "30ede62e194f692f2dd3daa09c752196";
    };
  };

  atk = {
    name = "atk-1.8.0";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/atk-1.8.0.tar.bz2;
      md5 = "fc46940febb0e91427b77457e6356f3d";
    };
  };

  audiofile = {
    name = "audiofile-0.2.6";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/audiofile-0.2.6.tar.bz2;
      md5 = "3d01302834660850b6141cac1e6f5501";
    };
  };

  esound = {
    name = "esound-0.2.35";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/esound-0.2.35.tar.bz2;
      md5 = "1566344f80a8909b5e6e4d6b6520c2c1";
    };
  };

  gail = {
    name = "gail-1.8.2";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/gail-1.8.2.tar.bz2;
      md5 = "3b8be198ccb8a0d92cfb0c3cdd519c1f";
    };
  };

  glib = {
    name = "glib-2.4.8";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/glib-2.4.8.tar.bz2;
      md5 = "e160a5feecf46e0fbb36db09c356953c";
    };
  };

  gnomemimedata = {
    name = "gnome-mime-data-2.4.2";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/gnome-mime-data-2.4.2.tar.bz2;
      md5 = "37242776b08625fa10c73c18b790e552";
    };
  };

  gnomevfs = {
    name = "gnome-vfs-2.8.4";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/gnome-vfs-2.8.4.tar.bz2;
      md5 = "42d3505e9ef9c26a7aae4e511b9b4c34";
    };
  };

  gtk = {
    name = "gtk+-2.4.14";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/gtk+-2.4.14.tar.bz2;
      md5 = "10470d574933460809e4ac488e579e26";
    };
  };

  libIDL = {
    name = "libIDL-0.8.5";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/libIDL-0.8.5.tar.bz2;
      md5 = "c63f6513dc7789d0575bea02d62d58d7";
    };
  };

  libart_lgpl = {
    name = "libart_lgpl-2.3.17";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/libart_lgpl-2.3.17.tar.bz2;
      md5 = "dfca42529393c8a8f59dc4dc10675a46";
    };
  };

  libbonobo = {
    name = "libbonobo-2.8.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/libbonobo-2.8.1.tar.bz2;
      md5 = "54f863c20016cf8a2cf25056f6c7cda7";
    };
  };

  libbonoboui = {
    name = "libbonoboui-2.8.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/libbonoboui-2.8.1.tar.bz2;
      md5 = "b23daafa8344a88696d497f20285ef55";
    };
  };

  libglade = {
    name = "libglade-2.4.2";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/libglade-2.4.2.tar.bz2;
      md5 = "83d08f9ab485a10454bd5171d2d53fb0";
    };
  };

  libgnome = {
    name = "libgnome-2.8.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/libgnome-2.8.1.tar.bz2;
      md5 = "17577198f5086c48f69c361be2f4806c";
    };
  };

  libgnomecanvas = {
    name = "libgnomecanvas-2.8.0";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/libgnomecanvas-2.8.0.tar.bz2;
      md5 = "2bf10396a92777e7b64b6052a8a232f1";
    };
  };

  libgnomeprint = {
    name = "libgnomeprint-2.8.2";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/libgnomeprint-2.8.2.tar.bz2;
      md5 = "8361c4e1bc3d87b91435807d0c06a3e4";
    };
  };

  libgnomeprintui = {
    name = "libgnomeprintui-2.8.2";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/libgnomeprintui-2.8.2.tar.bz2;
      md5 = "b38d1f6813dd52879ba4174ddc3f1b1c";
    };
  };

  libgnomeui = {
    name = "libgnomeui-2.8.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/libgnomeui-2.8.1.tar.bz2;
      md5 = "d46a2b34bdfbc1b36464176fa8bef03c";
    };
  };

  pango = {
    name = "pango-1.6.0";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/pango-1.6.0.tar.bz2;
      md5 = "6c732bbc5fba5a0f1f8086e8aa4f490d";
    };
  };

  intltool = {
    name = "intltool-0.33";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/intltool-0.33.tar.bz2;
      md5 = "7d3b6d421b0fb9beee7faf97daab45e6";
    };
  };
  
}

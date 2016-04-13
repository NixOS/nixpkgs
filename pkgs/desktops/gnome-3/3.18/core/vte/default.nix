{ stdenv, fetchurl, intltool, pkgconfig
, gnome3, ncurses, gobjectIntrospection, vala, libxml2, gnutls

, selectTextPatch ? false
, fetchFromGitHub, autoconf, automake, libtool, gtk_doc, gperf
}:

let baseAttrs = rec {
  inherit (import ./src.nix fetchurl) name src;

  buildInputs = [ gobjectIntrospection intltool pkgconfig gnome3.glib
                  gnome3.gtk3 ncurses vala libxml2 ];

  propagatedBuildInputs = [ gnutls ];

  preConfigure = "patchShebangs .";

  configureFlags = [ "--enable-introspection" ];

  enableParallelBuilding = true;

  postInstall = ''
    substituteInPlace $out/lib/libvte2_90.la --replace "-lncurses" "-L${ncurses.out}/lib -lncurses"
  '';

  meta = with stdenv.lib; {
    homepage = http://www.gnome.org/;
    description = "A library implementing a terminal emulator widget for GTK+";
    longDescription = ''
      VTE is a library (libvte) implementing a terminal emulator widget for
      GTK+, and a minimal sample application (vte) using that.  Vte is
      mainly used in gnome-terminal, but can also be used to embed a
      console/terminal in games, editors, IDEs, etc. VTE supports Unicode and
      character set conversion, as well as emulating any terminal known to
      the system's terminfo database.
    '';
    license = licenses.lgpl2;
    maintainers = with maintainers; [ astsmtl antono lethalman ];
    platforms = platforms.linux;
  };
};

in stdenv.mkDerivation ( baseAttrs
  // stdenv.lib.optionalAttrs selectTextPatch rec {
      name = "vte-ng-${version}";
      version = "0.42.4.a";
      src = fetchFromGitHub {
        owner = "thestinger";
        repo = "vte-ng";
        rev = version;
        sha256 = "1w91lz30j5lrskp9ds5j3nn27m5mpdpn7nlcvf5y1w63mpmjg8k1";
      };
      # slightly hacky; I couldn't make it work with autoreconfHook
      configureScript = "./autogen.sh";
      nativeBuildInputs = (baseAttrs.nativeBuildInputs or [])
        ++ [ gtk_doc autoconf automake libtool gperf ];
  }
)


{ stdenv, fetchurl, fetchFromBitbucket, autoreconfHook, gtk-doc, gettext
, pkg-config, glib, libxml2, gobject-introspection, gnome-common, unzip
}:

stdenv.mkDerivation rec {
  pname = "liblangtag";
  version = "0.6.3";

  src = fetchFromBitbucket {
    owner = "tagoh";
    repo = pname;
    rev = version;
    sha256 = "10rycs8xrxzf9frzalv3qx8cs1jcildhrr4imzxdmr9f4l585z96";
  };

  core_zip = fetchurl {
    # please update if an update is available
    url = "http://www.unicode.org/Public/cldr/37/core.zip";
    sha256 = "0myswkvvaxvrz9zwq4zh65sygfd9n72cd5rk4pwacqba4nxgb4xs";
  };

  language_subtag_registry = fetchurl {
    url = "http://www.iana.org/assignments/language-subtag-registry";
    sha256 = "0y9x5gra6jri4sk16f0dp69p06almnsl48rs85605f035kf539qm";
  };

  postPatch = ''
    gtkdocize
    cp "${core_zip}" data/core.zip
    touch data/stamp-core-zip
    cp "${language_subtag_registry}" data/language-subtag-registry
  '';

  configureFlags = [
    ''--with-locale-alias=${stdenv.cc.libc}/share/locale/locale.alias''
  ];

  buildInputs = [ gettext glib libxml2 gobject-introspection gnome-common
    unzip ];
  nativeBuildInputs = [ autoreconfHook gtk-doc gettext pkg-config ];

  meta = {
    inherit version;
    description = "An interface library to access tags for identifying languages";
    license = stdenv.lib.licenses.mpl20;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
    # There are links to a homepage that are broken by a BitBucket change
    homepage = "https://bitbucket.org/tagoh/liblangtag/overview";
  };
}

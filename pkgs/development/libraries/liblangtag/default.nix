{stdenv, fetchurl, fetchFromBitbucket, autoreconfHook, gtkdoc, gettext
, pkgconfig, glib, libxml2, gobject-introspection, gnome-common, unzip
}:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "liblangtag";
  version = "0.6.1";

  src = fetchFromBitbucket {
    owner = "tagoh";
    repo = "${pname}";
    rev = "${version}";
    sha256 = "19dk2qsg7f3ig9xz8d73jvikmf5kvrwi008wrz2psxinbdml442g";
  };

  core_zip = fetchurl {
    # please update if an update is available
    url = "http://www.unicode.org/Public/cldr/33.1/core.zip";
    sha256 = "0f195aald02ng3ch2q1wf59b5lwp2bi1cd8ia7572pbyy2w8w8cp";
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
  nativeBuildInputs = [ autoreconfHook gtkdoc gettext pkgconfig ];

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

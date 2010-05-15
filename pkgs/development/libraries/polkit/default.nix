{ stdenv, fetchurl, pkgconfig, glib, eggdbus, expat, pam, intltool, gettext,
  gobjectIntrospection }:

stdenv.mkDerivation rec {
  name = "polkit-0.96";
  
  src = fetchurl {
    url = "http://hal.freedesktop.org/releases/${name}.tar.gz";
    sha256 = "0jh5v0dhf9msvmfmr9d67563m64gq5l96m9jax9abchhfa8wl9il";
  };
  
  buildInputs = [ pkgconfig glib eggdbus expat pam intltool gettext
    gobjectIntrospection ];

  configureFlags = "--localstatedir=/var --sysconfdir=/etc";
# TODO: PACKAGE_DATA_DIR, PACKAGE_LIBEXEC_DIR, PACKAGE_LIB_DIR

  installFlags = "localstatedir=$(TMPDIR)/var"; # keep `make install' happy
  
  postInstall =
    ''
      # Allow some files with paranoid permissions to be stripped in
      # the fixup phase.
      chmod a+rX -R $out
    '';

  meta = with stdenv.lib; {
    homepage = http://www.freedesktop.org/wiki/Software/PolicyKit;
    description = "A toolkit for defining and handling the policy that allows unprivileged processes to speak to privileged processes";
    platforms = platforms.linux;
    maintainers = [ maintainers.urkud ];
  };
}

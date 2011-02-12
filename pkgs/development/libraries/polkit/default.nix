{ stdenv, fetchurl, pkgconfig, glib, eggdbus, expat, pam, intltool, gettext,
  gobjectIntrospection }:

let
  system="/var/run/current-system/sw";
  foolVars = {
    LOCALSTATE = "/var";
    SYSCONF = "/etc";
    LIBEXEC = "${system}/libexec/polkit-1";
    LIB = "${system}/lib";
    DATA = "${system}/share";
  };
in

stdenv.mkDerivation rec {
  name = "polkit-0.99";

  src = fetchurl {
    url = "http://hal.freedesktop.org/releases/${name}.tar.gz";
    sha256 = "0gsqnc5x6angma7paw0hnl5cagqimsj5f022a5vzc8n8dv1cf4pn";
  };

  buildInputs = [ pkgconfig glib eggdbus expat pam intltool gettext
    gobjectIntrospection ];

  preConfigure=''
    configureFlags="--libexecdir=$out/libexec/polkit-1"
  '';

  # Ugly hack to overwrite hardcoded directories
  # TODO: investigate a proper patch which will be accepted upstream
  CFLAGS = stdenv.lib.concatStringsSep " "
    ( map (var: ''-DPACKAGE_${var}_DIR=\""${builtins.getAttr var foolVars}"\"'')
    (builtins.attrNames foolVars) );

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

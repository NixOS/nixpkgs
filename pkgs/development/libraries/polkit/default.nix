{ stdenv, fetchurl, pkgconfig, glib, expat, pam, intltool, gettext
, gobjectIntrospection }:

let

  system = "/var/run/current-system/sw";
  
  foolVars = {
    LOCALSTATE = "/var";
    SYSCONF = "/etc";
    LIB = "${system}/lib";
    DATA = "${system}/share";
  };
  
in

stdenv.mkDerivation rec {
  name = "polkit-0.102";

  src = fetchurl {
    url = "http://hal.freedesktop.org/releases/${name}.tar.gz";
    sha256 = "0hc60nwqnmixavgg0alk4w0llwj5xmm4bw8qh915qvqwhkd76r8a";
  };

  buildInputs =
    [ pkgconfig glib expat pam intltool gobjectIntrospection ];

  configureFlags = "--libexecdir=$(out)/libexec/polkit-1";

  # Ugly hack to overwrite hardcoded directories
  # TODO: investigate a proper patch which will be accepted upstream
  CFLAGS = stdenv.lib.concatStringsSep " "
    ( map (var: ''-DPACKAGE_${var}_DIR=\""${builtins.getAttr var foolVars}"\"'')
        (builtins.attrNames foolVars) );

  makeFlags =
    ''
      INTROSPECTION_GIRDIR=$(out)/share/gir-1.0
      INTROSPECTION_TYPELIBDIR=$(out)lib/girepository-1.0
    '';
        
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

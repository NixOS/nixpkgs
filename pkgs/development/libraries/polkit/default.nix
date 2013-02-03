{ stdenv, fetchurl, pkgconfig, glib, expat, pam, intltool, gettext
, gobjectIntrospection
, useSystemd ? true, systemd }:

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
  name = "polkit-0.105";

  src = fetchurl {
    url = "http://www.freedesktop.org/software/polkit/releases/${name}.tar.gz";
    sha256 = "1pz1hn4z0f1wk4f7w8q1g6ygwan1b6kxmfad3b7gql27pb47rp4g";
  };

  buildInputs =
    [ pkgconfig glib expat pam intltool gobjectIntrospection ]
    ++ stdenv.lib.optional useSystemd systemd;

  configureFlags = "--libexecdir=$(out)/libexec/polkit-1";

  # Ugly hack to overwrite hardcoded directories
  # TODO: investigate a proper patch which will be accepted upstream
  CFLAGS = stdenv.lib.concatStringsSep " "
    ( map (var: ''-DPACKAGE_${var}_DIR=\""${builtins.getAttr var foolVars}"\"'')
        (builtins.attrNames foolVars) );

  preBuild =
    ''
      # ‘libpolkit-agent-1.so’ should call the setuid wrapper on
      # NixOS.  Hard-coding the path is kinda ugly.  Maybe we can just
      # call through $PATH, but that might have security implications.
      substituteInPlace src/polkitagent/polkitagentsession.c \
        --replace PACKAGE_LIBEXEC_DIR '"/var/setuid-wrappers"'
    '';

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
    homepage = http://www.freedesktop.org/wiki/Software/polkit;
    description = "A toolkit for defining and handling the policy that allows unprivileged processes to speak to privileged processes";
    platforms = platforms.linux;
    maintainers = [ maintainers.urkud ];
  };
}

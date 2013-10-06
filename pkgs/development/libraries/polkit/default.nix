{ stdenv, fetchurl, pkgconfig, glib, expat, pam, intltool, spidermonkey
, gobjectIntrospection
, useSystemd ? stdenv.isLinux, systemd }:

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
  name = "polkit-0.112";

  src = fetchurl {
    url = "http://www.freedesktop.org/software/polkit/releases/${name}.tar.gz";
    sha256 = "1xkary7yirdcjdva950nqyhmsz48qhrdsr78zciahj27p8yg95fn";
  };

  buildInputs =
    [ pkgconfig glib expat pam intltool spidermonkey gobjectIntrospection ]
    ++ stdenv.lib.optional useSystemd systemd;

  preConfigure = ''
    patchShebangs .
  '' + stdenv.lib.optionalString useSystemd /* bogus chroot detection */ ''
    sed '/libsystemd-login autoconfigured, but system does not appear to use systemd/s/.*/:/' -i configure
  '';

  # TODO: Distro/OS detection is impure
  configureFlags = [
    "--libexecdir=$(out)/libexec/polkit-1"
    "--with-systemdsystemunitdir=$(out)/etc/systemd/system"
  ];

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

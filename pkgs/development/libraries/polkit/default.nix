{ stdenv, fetchurl, pkgconfig, glib, eggdbus, expat, pam, intltool, gettext }:

stdenv.mkDerivation rec {
  name = "policy-kit-0.92";
  
  src = fetchurl {
    url = http://hal.freedesktop.org/releases/polkit-0.92.tar.gz;
    sha256 = "18x4xp4m14fm4aayra4njh82g2jzf6ccln40yybmhxqpb5a3nii8";
  };
  
  buildInputs = [ pkgconfig glib eggdbus expat pam intltool gettext ];

  configureFlags = "--localstatedir=/var";

  installFlags = "localstatedir=$(TMPDIR)/var"; # keep `make install' happy
  
  postInstall =
    ''
      # Allow some files with paranoid permissions to be stripped in
      # the fixup phase.
      chmod a+rX -R $out

      # Fix the pathname in the frobnicate example.
      substituteInPlace $out/share/polkit-1/actions/org.freedesktop.policykit.examples.pkexec.policy \
          --replace /usr/bin/pk-example-frobnicate $out/bin/pk-example-frobnicate
    '';

  meta = {
    homepage = http://www.freedesktop.org/wiki/Software/PolicyKit;
    description = "A toolkit for defining and handling the policy that allows unprivileged processes to speak to privileged processes";
  };
}

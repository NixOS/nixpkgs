{ stdenv, fetchFromGitHub, fetchpatch, pantheon }:

stdenv.mkDerivation rec {
  pname = "default-settings";
  version = "5.1.0";

  name = "elementary-${pname}-${version}";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "0l73py4rr56i4dalb2wh1c6qiwmcjkm0l1j75jp5agcnxldh5wym";
  };

  passthru = {
    updateScript = pantheon.updateScript {
      repoName = pname;
      attrPath = "elementary-${pname}";
    };
  };

  patches = [
    ./correct-override.patch
  ];

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/etc/gtk-3.0
    cp -av settings.ini $out/etc/gtk-3.0

    mkdir -p $out/share/glib-2.0/schemas
    cp -av overrides/default-settings.gschema.override $out/share/glib-2.0/schemas/20-io.elementary.desktop.gschema.override

    mkdir $out/etc/wingpanel.d
    cp -avr ${./io.elementary.greeter.whitelist} $out/etc/wingpanel.d/io.elementary.greeter.whitelist

    mkdir -p $out/share/elementary/config/plank/dock1
    cp -avr ${./launchers} $out/share/elementary/config/plank/dock1/launchers
  '';

  meta = with stdenv.lib; {
    description = "Default settings and configuration files for elementary";
    homepage = https://github.com/elementary/default-settings;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };
}

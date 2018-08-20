{ stdenv, fetchFromGitHub, fetchpatch, pantheon }:

stdenv.mkDerivation rec {
  pname = "default-settings";
  version = "5.0";

  name = "elementary-${pname}-${version}";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "0gyv835qbr90001gda2pzngzzbbk5jf9grgfl25pqkm29s45rqq0";
  };

  passthru = {
    updateScript = pantheon.updateScript {
      repoName = pname;
      attrPath = "elementary-${pname}";
    };
  };

  patches = [
    # See: https://github.com/elementary/default-settings/pull/86 (didn't make 5.0 release)
    (fetchpatch {
      url = "https://github.com/elementary/default-settings/commit/05d0b2a4e98c28203521d599b40745b46be549fa.patch";
      sha256 = "1wk1qva3yzc28gljnkx9hb3pwhqnfrsb08wd76lsl3xnylg0wn2l";
    })
    # See: https://github.com/elementary/default-settings/pull/94 (didn't make 5.0 release)
    (fetchpatch {
      url = "https://github.com/elementary/default-settings/commit/a2ca00130c16e805179fb5abd7b624a873dff2da.patch";
      sha256 = "1jp1c5d8jfm0404zsylfk7h9vj81s409wgbzbsd2kxmz65icq16x";
    })
    ./correct-override.patch
  ];

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/etc/gtk-3.0
    cp -av settings.ini $out/etc/gtk-3.0

    mkdir -p $out/share/glib-2.0/schemas
    cp -av debian/elementary-default-settings.gsettings-override $out/share/glib-2.0/schemas/20-io.elementary.desktop.gschema.override

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

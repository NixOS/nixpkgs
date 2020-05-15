{ stdenv
, fetchFromGitHub
, pantheon
, meson
, ninja
, desktop-file-utils
, glib
, coreutils
, elementary-settings-daemon
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "elementary-dpms-helper";
  version = "1.0";

  repoName = "dpms-helper";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = repoName;
    rev = version;
    sha256 = "0svfp0qyb6nx4mjl3jx4aqmb4x24m25jpi75mdis3yfr3c1xz9nh";
  };

  passthru = {
    updateScript = pantheon.updateScript {
      attrPath = "pantheon.${pname}";
    };
  };

  nativeBuildInputs = [
    desktop-file-utils
    meson
    ninja
    wrapGAppsHook
  ];

  buildInputs = [
    elementary-settings-daemon
    glib
  ];

  preFixup = ''
    gappsWrapperArgs+=(--prefix PATH : "${stdenv.lib.makeBinPath [ glib.dev coreutils ]}")
  '';

  postFixup = ''
    substituteInPlace $out/etc/xdg/autostart/io.elementary.dpms-helper.desktop \
      --replace "Exec=io.elementary.dpms-helper" "Exec=$out/bin/io.elementary.dpms-helper"
  '';

  # See: https://github.com/elementary/dpms-helper/pull/10
  postInstall = ''
    ${glib.dev}/bin/glib-compile-schemas $out/share/glib-2.0/schemas
  '';

  meta = with stdenv.lib; {
    description = "Sets DPMS settings found in org.pantheon.dpms";
    homepage = "https://github.com/elementary/dpms-helper";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };
}

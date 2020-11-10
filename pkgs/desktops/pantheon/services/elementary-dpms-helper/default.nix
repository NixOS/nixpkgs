{ stdenv
, fetchFromGitHub
, nix-update-script
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
    sha256 = "sha256-0KbfAxvZ+aFjq+XEK4uoRHSyKlaky0FlJd2a5TG4bms=";
  };

  passthru = {
    updateScript = nix-update-script {
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

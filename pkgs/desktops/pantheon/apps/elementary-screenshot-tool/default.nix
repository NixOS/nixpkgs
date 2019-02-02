{ stdenv, fetchFromGitHub, pantheon, pkgconfig, meson, callPackage
, ninja, vala, python3, desktop-file-utils, gtk3, granite, libgee
, libcanberra, gobject-introspection, elementary-icon-theme, wrapGAppsHook }:

let

  redacted-script = callPackage ./redacted-script.nix {};

in

stdenv.mkDerivation rec {
  pname = "screenshot-tool"; # This will be renamed to "screenshot" soon. See -> https://github.com/elementary/screenshot/pull/93
  version = "1.6.1";

  name = "elementary-${pname}-${version}";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "screenshot";
    rev = version;
    sha256 = "1vvj550md7vw7n057h8cy887a0nmsbwry67dxrxyz6bsvpk8sb6g";
  };

  passthru = {
    updateScript = pantheon.updateScript {
      repoName = "screenshot";
      attrPath = "elementary-${pname}";
    };
  };

  nativeBuildInputs = [
    desktop-file-utils
    gobject-introspection
    meson
    ninja
    pkgconfig
    python3
    vala
    wrapGAppsHook
  ];

  buildInputs = [
    elementary-icon-theme
    granite
    gtk3
    libcanberra
    libgee
  ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  postInstall = ''
    mkdir -p $out/share/fonts/truetype
    cp -rva ${redacted-script}/share/fonts/truetype/redacted-elementary $out/share/fonts/truetype
  '';

  meta = with stdenv.lib; {
    description = "Screenshot tool designed for elementary OS";
    homepage = https://github.com/elementary/screenshot;
    license = licenses.lgpl3;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };
}

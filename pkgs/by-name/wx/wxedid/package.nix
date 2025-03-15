{
  lib,
  stdenv,
  fetchFromGitHub,
  wxGTK32,
  makeWrapper,
  gsettings-desktop-schemas,
  gtk3,
}:
stdenv.mkDerivation rec {
  pname = "wxedid";
  version = "0.0.27";

  src = fetchFromGitHub {
    owner = "ruineka";
    repo = "wxEDID";
    rev = "v${version}";
    hash = "sha256-g3D9dBrs/zIU/4T1hzpcj2lROCgrDMPIMZyL5uqxjB0=";
  };
  nativeBuildInputs = [
    makeWrapper
  ];
  buildInputs = [
    gsettings-desktop-schemas
    wxGTK32
  ];
  prePatch = ''
    patchShebangs --build src
  '';
  preFixup = ''
    wrapProgram $out/bin/wxedid --prefix GSETTINGS_SCHEMA_DIR : "${gtk3}/share/gsettings-schemas/${gtk3.name}/glib-2.0/schemas"
  '';

  meta = with lib; {
    description = "wxWidgets-based EDID (Extended Display Identification Data) editor";
    homepage = "https://github.com/ruineka/wxEDID";
    license = licenses.gpl3Only;
    mainProgram = "wxedid";
    maintainers = [ maintainers.meanwhile131 ];
    platforms = lib.platforms.linux;
  };
}

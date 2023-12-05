{ stdenv, fetchFromGitHub, lib
, pkg-config, cmake
, gtk-doc
, gtk3, libayatana-indicator, libdbusmenu-gtk3
, vala
, gobject-introspection
}:

stdenv.mkDerivation rec {
  pname = "libayatana-appindicator";
  version = "0.5.92";

  outputs = [ "out" "dev" ];

  src = fetchFromGitHub {
    owner = "AyatanaIndicators";
    repo = "libayatana-appindicator";
    rev = version;
    sha256 = "sha256-NzaWQBb2Ez1ik23wCgW1ZQh1/rY7GcPlLvaSgV7uXrA=";
  };

  nativeBuildInputs = [ pkg-config cmake gtk-doc vala gobject-introspection ];

  buildInputs = [ gtk3 ];

  propagatedBuildInputs = [ libayatana-indicator libdbusmenu-gtk3 ];

  cmakeFlags = [
    "-DENABLE_BINDINGS_MONO=False"
  ];

  meta = with lib; {
    description = "Ayatana Application Indicators Shared Library";
    homepage = "https://github.com/AyatanaIndicators/libayatana-appindicator";
    changelog = "https://github.com/AyatanaIndicators/libayatana-appindicator/blob/${version}/ChangeLog";
    license = [ licenses.lgpl3Plus licenses.lgpl21Plus ];
    maintainers = [ maintainers.nickhu ];
    platforms = platforms.linux;
  };
}

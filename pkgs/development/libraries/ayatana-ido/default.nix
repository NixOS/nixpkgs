{ lib, stdenv, fetchFromGitHub
, pkg-config, cmake
, gtk3
}:

stdenv.mkDerivation rec {
  pname = "ayatana-ido";
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "AyatanaIndicators";
    repo = pname;
    rev = version;
    sha256 = "sha256-uecUyqSL02SRdlLbWIy0luHACTFoyMXQ6rOIYuisZsw=";
  };

  nativeBuildInputs = [ pkg-config cmake ];

  buildInputs = [ gtk3 ];

  meta = with lib; {
    description = "Ayatana Display Indicator Objects";
    homepage = "https://github.com/AyatanaIndicators/ayatana-ido";
    changelog = "https://github.com/AyatanaIndicators/ayatana-ido/blob/${version}/ChangeLog";
    license = [ licenses.lgpl3Plus licenses.lgpl21Plus ];
    maintainers = [ maintainers.nickhu ];
    platforms = platforms.linux;
  };
}

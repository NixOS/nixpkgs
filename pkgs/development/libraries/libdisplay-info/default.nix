{ lib
, stdenv
, fetchFromGitLab
, meson
, pkg-config
, ninja
, python3
, hwdata
, edid-decode
}:

stdenv.mkDerivation rec {
  pname = "libdisplay-info";
  version = "0.1.0";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "emersion";
    repo = pname;
    rev = version;
    sha256 = "sha256-jfi7RpEtyQicW0WWhrQg28Fta60YWxTbpbmPHmXxDhw=";
  };

  nativeBuildInputs = [ meson pkg-config ninja edid-decode python3 ];

  buildInputs = [ hwdata ];

  postPatch = ''
    patchShebangs tool/gen-search-table.py
  '';

  meta = with lib; {
    description = "EDID and DisplayID library";
    homepage = "https://gitlab.freedesktop.org/emersion/libdisplay-info";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ pedrohlc ];
  };
}

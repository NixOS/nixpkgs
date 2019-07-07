{ stdenv, fetchFromGitHub, meson, ninja, python3, gtk3, pantheon }:

stdenv.mkDerivation rec {
  name = "${package-name}-${version}";
  package-name = "faba-icon-theme";
  version = "4.3";

  src = fetchFromGitHub {
    owner = "moka-project";
    repo = package-name;
    rev = "v${version}";
    sha256 = "0xh6ppr73p76z60ym49b4d0liwdc96w41cc5p07d48hxjsa6qd6n";
  };

  nativeBuildInputs = [ meson ninja python3 gtk3 pantheon.elementary-icon-theme ];

  postPatch = ''
    patchShebangs meson/post_install.py
  '';

  meta = with stdenv.lib; {
    description = "A sexy and modern icon theme with Tango influences";
    homepage = https://snwh.org/moka;
    license = with licenses; [ cc-by-sa-40 gpl3 ];
    platforms = platforms.all;
    maintainers = with maintainers; [ romildo ];
  };
}

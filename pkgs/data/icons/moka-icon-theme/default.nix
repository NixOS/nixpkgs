{ stdenv, fetchFromGitHub, meson, ninja, gtk3, python3, faba-icon-theme }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "moka-icon-theme";
  version = "5.4.0";

  src = fetchFromGitHub {
    owner = "snwh";
    repo = pname;
    rev = "v${version}";
    sha256 = "015l02im4mha5z91dbchxf6xkp66d346bg3xskwg0rh3lglhjsrd";
  };

  nativeBuildInputs = [ meson ninja gtk3 python3 faba-icon-theme ];

  postPatch = ''
    patchShebangs meson/post_install.py
  '';

  meta = with stdenv.lib; {
    description = "An icon theme designed with a minimal flat style using simple geometry and bright colours";
    homepage = https://snwh.org/moka;
    license = with licenses; [ cc-by-sa-40 gpl3 ];
    # darwin cannot deal with file names differing only in case
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}

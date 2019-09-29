{ stdenv, fetchFromGitHub, meson, ninja, gtk3, python3, hicolor-icon-theme }:

stdenv.mkDerivation rec {
  pname = "paper-icon-theme";
  version = "2018-06-24";

  src = fetchFromGitHub {
    owner = "snwh";
    repo = pname;
    rev = "c7cd013fba06dd8fd5cdff9f885520e2923266b8";
    sha256 = "0x45zkjnmbz904df63ph06npbm3phpgck4xwyymx8r8jgrfplk6v";
  };

  nativeBuildInputs = [ meson ninja gtk3 python3 ];

  propagatedBuildInputs = [
    hicolor-icon-theme
  ];

  dontDropIconThemeCache = true;

  postPatch = ''
    patchShebangs meson/post_install.py
  '';

  postInstall = ''
    # The cache for Paper-Mono-Dark is missing
    gtk-update-icon-cache "$out"/share/icons/Paper-Mono-Dark;
  '';

  meta = with stdenv.lib; {
    description = "Modern icon theme designed around bold colours and simple geometric shapes";
    homepage = https://snwh.org/paper;
    license = with licenses; [ cc-by-sa-40 lgpl3 ];
    # darwin cannot deal with file names differing only in case
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}

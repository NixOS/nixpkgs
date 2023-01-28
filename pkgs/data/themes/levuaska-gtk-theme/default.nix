{ lib, stdenvNoCC, fetchFromGitHub, autoreconfHook, gtk_engines }:

stdenvNoCC.mkDerivation rec {
  version = "unstable-2021-01-31";
  pname = "levuaska-gtk-theme";

  src = fetchFromGitHub {
    owner = "selene57";
    repo = pname;
    rev = "eaf668545d2450a7cc1b9f8a1fbfcd50df8fa5d8";
    sha256 = "M43YyquFwwzxdhS9D+4nkaebHs1SDAz8cA+LcuU72LI=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  buildInputs = [ gtk_engines ];

  postPatch = ''
    substituteInPlace Makefile.am --replace '$(DESTDIR)'/usr $out
  '';

  preferLocalBuild = true;

  meta = with lib; {
    description = "A flat material dark gtk theme by saimoomedits inspired by owl4ce's fleon theme";
    homepage = "https://github.com/saimoomedits/levuaska";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.selene57 ];
  };
}

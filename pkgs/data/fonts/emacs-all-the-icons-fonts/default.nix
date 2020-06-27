{ lib, mkFont, fetchzip }:

mkFont rec {
  pname = "emacs-all-the-icons-fonts";
  version = "3.2.0";

  src = fetchzip {
    url = "https://github.com/domtronn/all-the-icons.el/archive/${version}.zip";
    sha256 = "1sdl33117lccznj38021lwcdnpi9nxmym295q6y460y4dm4lx0jn";
  };

  meta = with lib; {
    description = "Icon fonts for emacs all-the-icons";
    longDescription = ''
      The emacs package all-the-icons provides icons to improve
      presentation of information in emacs. This package provides
      the fonts needed to make the package work properly.
    '';
    homepage = "https://github.com/domtronn/all-the-icons.el";
    license = licenses.free; # MIT, SIL OFL, and Apache v2.0
    platforms = platforms.all;
    maintainers = with maintainers; [ rlupton20 ];
  };
}

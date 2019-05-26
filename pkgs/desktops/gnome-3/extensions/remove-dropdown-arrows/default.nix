{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "gnome-shell-extension-remove-dropdown-arrows-${version}";
  version = "11";

  src = fetchFromGitHub {
    owner = "mpdeimos";
    repo = "gnome-shell-remove-dropdown-arrows";
    rev = "version/${version}";
    sha256 = "1g99r9bpjdhab3xj74wkl40gdnaf2w51kswcr8mi6bq72n4wjxwh";
  };

  # This package has a Makefile, but it's used for publishing and linting, not
  # for building. Disable the build phase so installing doesn't attempt to
  # publish the extension.
  dontBuild = true;

  uuid = "remove-dropdown-arrows@mpdeimos.com";
  installPhase = ''
    mkdir -p $out/share/gnome-shell/extensions/${uuid}
    cp extension.js $out/share/gnome-shell/extensions/${uuid}
    cp metadata.json $out/share/gnome-shell/extensions/${uuid}
  '';

  meta = with stdenv.lib; {
    description = "Remove dropdown arrows from GNOME Shell Menus";
    license = licenses.gpl3;
    maintainers = with maintainers; [ jonafato ];
    homepage = https://github.com/mpdeimos/gnome-shell-remove-dropdown-arrows;
  };
}

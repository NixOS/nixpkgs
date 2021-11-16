{ lib
, stdenv
, fetchFromGitHub
, glib
, gnome-shell
, gnome-themes-extra
, libxml2
, sassc
, util-linux
}:

stdenv.mkDerivation rec {
  pname = "whitesur-gtk-theme";
  version = "2021-10-21";

  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = pname;
    rev = version;
    sha256 = "1rbwf6z2bda647kw00q2fp349gjzvdc4gyk986fkjli0nr0jh8hp";
  };

  nativeBuildInputs = [
    glib
    gnome-shell
    libxml2
    sassc
    util-linux
  ];

  buildInputs = [
    gnome-themes-extra # adwaita engine for Gtk2
  ];

  postPatch = ''
    find -name "*.sh" -print0 | while IFS= read -r -d ''' file; do
      patchShebangs "$file"
    done

    # Do not provide `sudo`, as it is not needed in our use case of the install script
    substituteInPlace lib-core.sh --replace '$(which sudo)' false

    # Provides a dummy home directory
    substituteInPlace lib-core.sh --replace 'MY_HOME=$(getent passwd "''${MY_USERNAME}" | cut -d: -f6)' 'MY_HOME=/tmp'
  '';

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/themes
    ./install.sh --dest $out/share/themes --alt all --theme all
    runHook postInstall
  '';

  meta = with lib; {
    description = "MacOS Big Sur like theme for Gnome desktops";
    homepage = "https://github.com/vinceliuice/WhiteSur-gtk-theme";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}

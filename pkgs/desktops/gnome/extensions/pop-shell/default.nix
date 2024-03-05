{ stdenv, lib, fetchFromGitHub, glib, gjs, typescript }:

stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-pop-shell";
  version = "unstable-2023-11-10";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "shell";
    rev = "aafc9458a47a68c396933c637de00421f5198a2a";
    hash = "sha256-74lZbEYHj7fufRSbuI2SN9rqbB3gpRa0V96qjAFc01s=";
  };

  nativeBuildInputs = [ glib gjs typescript ];

  buildInputs = [ gjs ];

  patches = [
    ./fix-gjs.patch
  ];

  makeFlags = [ "XDG_DATA_HOME=$(out)/share" ];

  passthru = {
    extensionUuid = "pop-shell@system76.com";
    extensionPortalSlug = "pop-shell";
  };

  postPatch = ''
    for file in */main.js; do
      substituteInPlace $file --replace "gjs" "${gjs}/bin/gjs"
    done
  '';

  preFixup = ''
    chmod +x $out/share/gnome-shell/extensions/pop-shell@system76.com/*/main.js
  '';

  meta = with lib; {
    description = "Keyboard-driven layer for GNOME Shell";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = [ maintainers.genofire ];
    homepage = "https://github.com/pop-os/shell";
  };
}

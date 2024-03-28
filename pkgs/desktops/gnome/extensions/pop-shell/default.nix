{ stdenv, lib, fetchFromGitHub, glib, gjs, typescript }:

stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-pop-shell";
  version = "unstable-2024-03-25";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "shell";
    rev = "fd30fe9121000064e3f29db1de02e2fbebbf98a9";
    hash = "sha256-H9Mzj0lAA+MG9MBba+GtBLIgNAvemsKsYJZasdGFUhM=";
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

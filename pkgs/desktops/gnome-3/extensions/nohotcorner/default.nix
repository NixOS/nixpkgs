{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "gnome-shell-extension-nohotcorner-${version}";
  version = "19.0";

  src = fetchFromGitHub {
    owner = "HROMANO";
    repo = "nohotcorner";
    rev = "v${version}";
    sha256 = "059n4gyz7d686hknaifyjax8gygrda1xab5m15a09p98jdrdfdhi";
  };

  # Taken from the extension download link at
  # https://extensions.gnome.org/extension/118/no-topleft-hot-corner/
  uuid = "nohotcorner@azuri.free.fr";

  installPhase = ''
    mkdir -p $out/share/gnome-shell/extensions/${uuid}
    cp extension.js $out/share/gnome-shell/extensions/${uuid}
    cp metadata.json $out/share/gnome-shell/extensions/${uuid}
  '';

  meta = with stdenv.lib; {
    description = "Disables the top left hot corner";
    license = licenses.gpl2;
    maintainers = with maintainers; [ jonafato ];
    homepage = https://github.com/HROMANO/nohotcorner;
  };
}

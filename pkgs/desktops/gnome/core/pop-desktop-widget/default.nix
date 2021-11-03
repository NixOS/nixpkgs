{ stdenv, fetchFromGitHub, rustPlatform, lib, pkg-config, glib, gst_all_1, gtk3, libhandy }:

stdenv.mkDerivation rec {
  pname = "pop-desktop-widget";
  version = "unstable-2021-11-03";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "desktop-widget";
    rev = "1652fc89aa16dcf652422c4c3dfe1095e6286b7d";
    sha256 = "sha256-QBQBtBSj+J87yAQhYMOrJTUCee3ebJhVc4Y/7EyBDes=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-/Sa/eImZZ+XeeCJueZOEhAmz0MA9yjW58jbFmXk4HL0=";
  };

  nativeBuildInputs = [ pkg-config glib rustPlatform.cargoSetupHook rustPlatform.rust.cargo ];
  buildInputs = [ gst_all_1.gstreamer gtk3 libhandy ];

  installFlags = [ "prefix=$(out)" "DESTDIR=" ];

  meta = with lib; {
    description = "GTK desktop settings widget for Pop!_OS";
    maintainers = with maintainers; [ Enzime ];
    license = licenses.mit;
    homepage = "https://github.com/pop-os/desktop-widget";
  };
}

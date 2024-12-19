{
  rustPlatform,
  fetchFromGitLab,
  lib,
  makeWrapper,
  gst_all_1,
  libsixel,
}:

rustPlatform.buildRustPackage rec {
  pname = "termplay";
  version = "2.0.6";

  src = fetchFromGitLab {
    owner = "jD91mZM2";
    repo = "termplay";
    rev = "v${version}";
    sha256 = "1w7hdqgqr1jgxid3k7f2j52wz31gv8bzr9rsm6xzp7nnihp6i45p";
  };

  cargoHash = "sha256-i7toHEewkpQ85aj4PK4SLJQCfUllUqkqIWLaOEk3NyI=";

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-ugly
    gst_all_1.gst-plugins-bad
    libsixel
  ];

  buildFeatures = [ "bin" ];

  postInstall = ''
    wrapProgram $out/bin/termplay --prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "$GST_PLUGIN_SYSTEM_PATH_1_0"
  '';

  meta = with lib; {
    description = "Play an image/video in your terminal";
    homepage = "https://jd91mzm2.github.io/termplay/";
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.unix;
    mainProgram = "termplay";
  };
}

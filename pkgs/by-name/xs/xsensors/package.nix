{
  lib,
  stdenv,
  fetchFromGitHub,
  gtk3,
  pkg-config,
  lm_sensors,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xsensors";
  version = "0.80";

  src = fetchFromGitHub {
    owner = "Mystro256";
    repo = "xsensors";
    tag = finalAttrs.version;
    hash = "sha256-dITnIMvOYL1gmoDP2w4ZlxcBdAqA/+D3ojm5cP+tTFQ=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    gtk3
    lm_sensors
  ];

  meta = {
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
})

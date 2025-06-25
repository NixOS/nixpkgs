{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "triforce-lv2";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "chadmed";
    repo = "triforce";
    tag = finalAttrs.version;
    hash = "sha256-f4i0S6UaVfs1CUeQRqo22PRgMNwYDNoMunHidI1XzBk=";
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail "target/release" \
                     "target/${stdenv.hostPlatform.rust.cargoShortTarget}/$cargoBuildType"
  '';

  cargoHash = "sha256-2FC6wlFJkQryA/bcjF0GjrMQVb8hlUY+muFqPqShWss=";

  dontCargoInstall = true;

  installFlags = [
    "DESTDIR=$(out)"
    "LIBDIR=lib"
  ];

  meta = with lib; {
    homepage = "https://github.com/chadmed/triforce";
    description = "Minimum Variance Distortionless Response adaptive beamformer for the microphone array found in some Apple Silicon laptops";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [
      normalcea
      yuka
    ];
    platforms = platforms.linux;
  };
})

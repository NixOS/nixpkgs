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
    description = "Beamformer for Apple Silicon laptops";
    longDescription = ''
      Triforce implements a Minimum Variance Distortionless Response
      adaptive beamformer for the microphone array found in the
      following Apple Silicon laptops:

      - MacBook Pro 13" (M1/M2)
      - MacBook Air 13" (M1/M2)
      - MacBook Pro 14" (M1 Pro/Max, M2 Pro/Max)
      - MacBook Pro 16" (M1 Pro/Max, M2 Pro/Max)
      - MacBook Air 15" (M2)
    '';
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [
      normalcea
      yuka
    ];
    platforms = platforms.linux;
  };
})

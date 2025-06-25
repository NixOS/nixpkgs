{
  lib,
  rustPlatform,
  fetchFromGitHub,
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

  useFetchCargoVendor = true;
  cargoHash = "sha256-2FC6wlFJkQryA/bcjF0GjrMQVb8hlUY+muFqPqShWss=";

  installPhase =
    let
      target = rustPlatform.cargoInstallHook.targetSubdirectory;
    in
    ''
      runHook preInstall

      installPath=$out/lib/lv2/triforce.lv2
      install -Dm0755 target/${target}/release/libtriforce.so $installPath/triforce.so
      install -Dm0644 {triforce,manifest}.ttl $installPath

      runHook postInstall
    '';

  meta = {
    homepage = "https://github.com/chadmed/triforce";
    description = "Minimum Variance Distortionless Response adaptive beamformer for the microphone array found in some Apple Silicon laptops";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      yuka
    ];
    platforms = lib.platforms.linux;
  };
})

{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nvidiaSupport ? false,
  makeWrapper,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "zenith";
  version = "0.14.3";

  src = fetchFromGitHub {
    owner = "bvaisvil";
    repo = "zenith";
    rev = finalAttrs.version;
    hash = "sha256-D/o8JmKLiT8LhmJ6q2h7f5vJQNXAN5aCislxwDw9yqo=";
  };

  # remove cargo config so it can find the linker on aarch64-linux
  postPatch = ''
    rm .cargo/config
  '';

  cargoHash = "sha256-/SRZWbsAvV4rgEsVj5WRgc5KJZm+JvIs1QTgaK/+l+g=";

  nativeBuildInputs = [ rustPlatform.bindgenHook ] ++ lib.optional nvidiaSupport makeWrapper;

  buildFeatures = lib.optional nvidiaSupport "nvidia";

  postInstall = lib.optionalString nvidiaSupport ''
    wrapProgram $out/bin/zenith \
      --suffix LD_LIBRARY_PATH : "/run/opengl-driver/lib"
  '';

  meta = {
    description =
      "Sort of like top or htop but with zoom-able charts, network, and disk usage"
      + lib.optionalString nvidiaSupport ", and NVIDIA GPU usage";
    mainProgram = "zenith";
    homepage = "https://github.com/bvaisvil/zenith";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ wegank ];
    platforms = if nvidiaSupport then lib.platforms.linux else lib.platforms.unix;
  };
})

{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nvidiaSupport ? false,
  makeWrapper,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "zenith";
  version = "0.15.1";

  src = fetchFromGitHub {
    owner = "bvaisvil";
    repo = "zenith";
    rev = finalAttrs.version;
    hash = "sha256-kxxavotpejDcWgsP06BmhpCe46tsu8EIPuao9i3RUpg=";
  };

  # remove cargo config so it can find the linker on aarch64-linux
  postPatch = ''
    rm .cargo/config.toml
  '';

  cargoHash = "sha256-9c1c+DnGLyUpmevEn6H+9oD+aclvYAONaMutyQa7Fbc=";

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

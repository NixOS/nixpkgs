{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  nvidiaSupport ? false,
  makeWrapper,
}:

rustPlatform.buildRustPackage rec {
  pname = "zenith";
  version = "0.14.2";

  src = fetchFromGitHub {
    owner = "bvaisvil";
    repo = "zenith";
    rev = version;
    hash = "sha256-kMjDbWhey3SoT4hlEz2mEoSIICfI+X03PdBgTs5yxuI=";
  };

  # remove cargo config so it can find the linker on aarch64-linux
  postPatch = ''
    rm .cargo/config
  '';

  cargoHash = "sha256-M+I7+mcXn2UM340loy4OS6z+uZMxwiO/JwD0KjHvcFw=";

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
}

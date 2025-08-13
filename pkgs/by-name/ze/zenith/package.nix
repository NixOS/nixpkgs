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
  version = "0.14.1";

  src = fetchFromGitHub {
    owner = "bvaisvil";
    repo = "zenith";
    rev = version;
    hash = "sha256-y+/s0TDVAFGio5uCzHjf+kHFZB0G8dDgTt2xaqSSz1c=";
  };

  # remove cargo config so it can find the linker on aarch64-linux
  postPatch = ''
    rm .cargo/config
  '';

  cargoHash = "sha256-xfp+nR4ihaTO4AZHizYg4qqf9MR030Qb5bN2nzhbytQ=";

  nativeBuildInputs = [ rustPlatform.bindgenHook ] ++ lib.optional nvidiaSupport makeWrapper;

  buildFeatures = lib.optional nvidiaSupport "nvidia";

  postInstall = lib.optionalString nvidiaSupport ''
    wrapProgram $out/bin/zenith \
      --suffix LD_LIBRARY_PATH : "/run/opengl-driver/lib"
  '';

  meta = with lib; {
    description =
      "Sort of like top or htop but with zoom-able charts, network, and disk usage"
      + lib.optionalString nvidiaSupport ", and NVIDIA GPU usage";
    mainProgram = "zenith";
    homepage = "https://github.com/bvaisvil/zenith";
    license = licenses.mit;
    maintainers = with maintainers; [ wegank ];
    platforms = if nvidiaSupport then platforms.linux else platforms.unix;
  };
}

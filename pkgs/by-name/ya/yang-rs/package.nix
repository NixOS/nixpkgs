{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libyang,
  libclang,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "yang-rs";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "Rishik-Y";
    repo = "yang-rs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RsscEnB7LQDOXrrvt341EQZY9Eot6NZw9rgoVGEG1Tw=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-BoXovgMDbJisQNT0DvZc+FaBVW4SZX7oi7PtcMbgKhA=";

  nativeBuildInputs = [
    pkg-config
    libclang
  ];
  buildInputs = [
    libyang
  ];

  env.LIBCLANG_PATH = "${lib.getLib libclang}/lib";

  meta = {
    description = "Rust bindings for the libyang library";
    homepage = "https://github.com/holo-routing/yang-rs";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ Rishik-Y ];
  };
})

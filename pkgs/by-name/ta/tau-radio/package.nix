{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,

  pkg-config,

  alsa-lib,
  jack2,
  libogg,
  libopus,
  libopusenc,
  libshout,

  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tau-radio";
  version = "0.2.3";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "tau-org";
    repo = "tau-radio";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1SKlZ+htlCsO7ClZDbFbKyw8v9zgV5pKDEtL57D49f8=";
  };

  cargoHash = "sha256-X1uHKYgt9ddvr/cBDW9HaHawG5uv2sU416jyL/XTPF4=";

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    libogg
    libopus
    libopusenc
    libshout
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
    jack2
  ];

  # fatal error: 'opus.h' file not found
  env.NIX_CFLAGS_COMPILE = "-I${libopus.dev}/include/opus";

  postPatch = ''
    # The opusenc crate hardcodes `*const i8`, but bindgen generates `*const c_char`,
    # which is `u8` on `aarch64-linux`, causing a type mismatch on that platform
    substituteInPlace $cargoDepsCopy/*/opusenc-*/src/comments.rs \
      --replace-fail \
        "picture.as_ptr() as *const i8," \
        "picture.as_ptr() as *const std::ffi::c_char,"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Web radio - Hijacks audio device using CLAP and Ogg/Opus";
    homepage = "https://github.com/tau-org/tau-radio";
    mainProgram = "tau-radio";
    license = lib.licenses.eupl12;
    maintainers = with lib.maintainers; [ eljamm ];
    teams = with lib.teams; [ ngi ];
  };
})

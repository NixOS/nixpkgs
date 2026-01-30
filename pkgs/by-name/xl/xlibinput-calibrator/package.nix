{
  lib,
  stdenv,
  fetchFromGitHub,
  libX11,
  libXi,
  libXrandr,
  txt2man,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xlibinput-calibrator";
  version = "0.11";

  src = fetchFromGitHub {
    owner = "kreijack";
    repo = "xlibinput_calibrator";
    rev = "v${finalAttrs.version}";
    hash = "sha256-MvlamN8WSER0zN9Ru3Kr2MFARD9s7PYKkRtyD8s6ZPI=";
  };

  nativeBuildInputs = [
    txt2man
  ];

  buildInputs = [
    libX11
    libXi
    libXrandr
  ];

  installFlags = [ "prefix=$(out)" ];

  enableParallelBuilding = true;

  meta = {
    description = "Touch calibrator for libinput";
    mainProgram = "xlibinput_calibrator";
    homepage = "https://github.com/kreijack/xlibinput_calibrator";
    changelog = "https://github.com/kreijack/xlibinput_calibrator/blob/${finalAttrs.src.rev}/Changelog";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ atemu ];
  };
})

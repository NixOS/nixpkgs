{
  lib,
  stdenv,
  autoreconfHook,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xtermcontrol";
  version = "3.12";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "JessThrysoee";
    repo = "xtermcontrol";
    tag = finalAttrs.version;
    hash = "sha256-+sLygwshLQKyqaZLzSPEy+VikSKFOS2E8Qah83wsTHE=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  doCheck = true;

  meta = {
    description = "Enables dynamic control of xterm properties";
    longDescription = ''
      Change colors, title, font, and geometry of a running xterm, and report
      the current settings. Window manipulations such as iconify, raise, lower,
      maximize, restore, and reset are supported. Advanced users can issue any
      xterm control sequence.
    '';
    homepage = "https://thrysoee.dk/xtermcontrol";
    changelog = "https://github.com/JessThrysoee/xtermcontrol/blob/${finalAttrs.version}/ChangeLog";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ iamanaws ];
    mainProgram = "xtermcontrol";
    platforms = lib.platforms.unix;
  };
})

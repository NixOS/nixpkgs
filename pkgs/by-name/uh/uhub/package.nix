{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  openssl,
  sqlite,
  pkg-config,
  systemd,
  versionCheckHook,

}:

stdenv.mkDerivation (finalAttrs: {
  pname = "uhub";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "janvidar";
    repo = "uhub";
    rev = finalAttrs.version;
    hash = "sha256-/o6i9/7PEWzgB9NhZMCWvmVV33kkympJPGXK1FdIWPc=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [
    openssl
    sqlite
    systemd
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "/usr/lib/uhub/" "$out/plugins" \
      --replace-fail "/etc/uhub" "$out/share/doc/uhub"
  '';

  cmakeFlags = [
    "-DSYSTEMD_SUPPORT=ON"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "-V";
  doInstallCheck = true;

  meta = {
    description = "High performance peer-to-peer hub for the ADC network";
    homepage = "https://www.uhub.org/";
    changelog = "https://github.com/janvidar/uhub/blob/${finalAttrs.src.rev}/ChangeLog";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.unix;
    mainProgram = "uhub";
  };
})

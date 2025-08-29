{
  lib,
  stdenv,
  fetchFromGitHub,
  perl,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "moarvm";
  version = "2025.06";

  # nixpkgs-update: no auto update
  src = fetchFromGitHub {
    owner = "MoarVM";
    repo = "MoarVM";
    tag = finalAttrs.version;
    hash = "sha256-QtJ8cLAbsFJ26wkfQCbIMVU1ArWlAXjsQ/RJbQ0wRNo=";
    fetchSubmodules = true;
  };

  postPatch = ''
    patchShebangs .
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace Configure.pl \
      --replace '`/usr/bin/arch`' '"${stdenv.hostPlatform.darwinArch}"' \
      --replace '/usr/bin/arch' "$(type -P true)" \
      --replace '/usr/' '/nope/'
    substituteInPlace 3rdparty/dyncall/configure \
      --replace '`sw_vers -productVersion`' '"11.0"'
  '';

  configureScript = "${lib.getExe perl} ./Configure.pl";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    description = "VM with adaptive optimization and JIT compilation, built for Rakudo";
    homepage = "https://moarvm.org";
    license = lib.licenses.artistic2;
    maintainers = with lib.maintainers; [
      thoughtpolice
      sgo
      prince213
    ];
    mainProgram = "moar";
    platforms = lib.platforms.unix;
  };
})

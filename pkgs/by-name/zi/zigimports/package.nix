{
  lib,
  stdenv,
  fetchFromGitHub,
  zig_0_13,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zigimports";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "tusharsadhwani";
    repo = "zigimports";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2cri+5mhhTQqlkv9db/3CQ3rCMq4yW4drMoRTZBhndE=";
  };

  nativeBuildInputs = [
    zig_0_13.hook
  ];

  # Remove the system suffix on the program name.
  postInstall = ''
    mv $out/bin/zigimports{*,}
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Automatically remove unused imports and globals from Zig files";
    homepage = "https://github.com/tusharsadhwani/zigimports";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jmbaur ];
    mainProgram = "zigimports";
    inherit (zig_0_13.meta) platforms;
  };
})

{
  lib,
  stdenv,
  fetchFromGitHub,
  zig_0_16,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zigimports";
  version = "0.1.0-unstable-2026-07-25";

  src = fetchFromGitHub {
    owner = "tusharsadhwani";
    repo = "zigimports";
    rev = "bcfbb03a85553638f8a80e6596bdfaa93a0cc266";
    hash = "sha256-ARM+pmk0elu+uYnrEdIixq6AS0eyUeqobOAPteER76w=";
  };

  nativeBuildInputs = [
    zig_0_16
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
    inherit (zig_0_16.meta) platforms;
  };
})

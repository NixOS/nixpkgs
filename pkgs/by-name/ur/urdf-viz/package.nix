{
  autoPatchelfHook,
  fetchFromGitHub,
  rustPlatform,
  stdenv,
  libGL,
  xorg,
  lib,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "urdf-viz";
  version = "0.46.1";

  # Fetch source from github
  src = fetchFromGitHub {
    owner = "openrr";
    repo = "urdf-viz";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zn/theIULmRePz2/uEsZpeVBhOtqJ0K2xXGb/t+agK4=";
  };

  # Fetch all cargo dependencies based on lockfile generated for version
  # Note: This is only required as the lockfile is not present in the github repository
  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';
  cargoLock =
    let
      fixupLockFile = path: (builtins.readFile path);
    in
    {
      lockFileContents = fixupLockFile ./Cargo.lock;
    };

  # Add all buildtime dependencies
  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];

  # Add all runtime dependencies
  buildInputs = [
    stdenv.cc.cc.lib
    libGL
    xorg.libX11
    xorg.libXcursor
    xorg.libXrandr
    xorg.libXinerama
    xorg.libXi
  ];

  # Tell autopatchelf about the dependency that is linked through dlopen
  runtimeDependencies = [
    libGL
    xorg.libX11
    xorg.libXcursor
    xorg.libXrandr
    xorg.libXinerama
    xorg.libXi
  ];

  meta = {
    description = "Visualizer for URDF and XACRO files";
    homepage = "https://github.com/openrr/urdf-viz";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ hrrs01 ];
  };
})

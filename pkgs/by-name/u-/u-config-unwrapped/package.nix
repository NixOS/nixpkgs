{
  lib,
  stdenv,
  fetchFromGitHub,
  installShellFiles,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "u-config";
  version = "0.33.3";

  src = fetchFromGitHub {
    owner = "skeeto";
    repo = "u-config";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2chZwS8aC7mbPJwsf5tju2ZNZNda650qT+ARjNJ2k2g=";
  };

  nativeBuildInputs = [
    installShellFiles
  ];

  dontConfigure = true;

  buildPhase = ''
    runHook preBuild

    # Every pkg-config implementation needs distro-specific configuration for where the .pc
    # files are installed, hence the default Makefile does not contain target for building
    # and installation, only for development. Instead of using it, we build the u-config via
    # manual CC invocation. Since on NixOS there is no global pc-path we set it to /var/empty
    # and rely on pkg-config-wrapper to provide the correct search path at runtime.
    $CC -DPKG_CONFIG_LIBDIR=\"/var/empty\" -Os \
      -o ${finalAttrs.meta.mainProgram} generic_main.c

    runHook postBuild
  '';

  installPhase =
    let
      binName = "${finalAttrs.meta.mainProgram}${stdenv.hostPlatform.extensions.executable}";
    in
    ''
      runHook preInstall

      installBin ${binName}
      installManPage u-config.1

      runHook postInstall
    '';

  meta = {
    description = "Smaller, simpler, portable pkg-config clone";
    homepage = "https://github.com/skeeto/u-config";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [ sigmanificient ];
    platforms = lib.platforms.all;
    mainProgram = "pkg-config";
  };
})

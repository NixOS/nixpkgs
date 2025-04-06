{
  lib,
  stdenv,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs:
let
  binary = finalAttrs.meta.mainProgram + stdenv.hostPlatform.extensions.executable;
  cppflags = lib.mapAttrsToList (name: value: "-D${name}=\"${value}\"") {
    # set these to empty strings as there are no central directories for
    # pkg-config modules, header files or libraries
    PKG_CONFIG_PREFIX = "";
    PKG_CONFIG_LIBDIR = "";
    PKG_CONFIG_SYSTEM_INCLUDE_PATH = "";
    PKG_CONFIG_SYSTEM_LIBRARY_PATH = "";
  };
in {
  pname = "u-config";
  version = "0.33.3";

  src = fetchFromGitHub {
    owner = "skeeto";
    repo = "u-config";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2chZwS8aC7mbPJwsf5tju2ZNZNda650qT+ARjNJ2k2g=";
  };

  nativeBuildInputs = [ installShellFiles ];

  dontConfigure = true;

  # build without using Makefile as recommended by upstream
  buildPhase = ''
    runHook preBuild

    $CC -o ${binary} ${lib.escapeShellArgs cppflags} generic_main.c

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    installBin ${binary}

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Smaller, simpler, portable pkg-config clone";
    homepage = "https://github.com/skeeto/u-config";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [ sigmanificient ];
    platforms = lib.platforms.all;
    mainProgram = "pkg-config";
  };
})

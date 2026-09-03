{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nodejs_22,
  nix-update-script,
  versionCheckHook,
}:

buildNpmPackage (finalAttrs: {
  pname = "zvec-grep";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "zvec-ai";
    repo = "zvec-grep";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2o/6QWyeZqOy7O8ikO8puqMXmtvWdjS9Y1rNW/SD/Bc=";
  };

  nodejs = nodejs_22;

  npmDepsHash = "sha256-NPFIAq618jy2wH7ikVg55LWLdPxjcU0OjniwZXPgEhk=";

  # Keep npm rebuild offline; the CPU runtime is bundled and CUDA is optional.
  env.ONNXRUNTIME_NODE_INSTALL_CUDA = "skip";

  # Node.js already provides the compiler runtime libraries, and the native
  # addons use $ORIGIN for their bundled shared-library dependencies.

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Local-first hybrid workspace search for humans and AI agents";
    homepage = "https://github.com/zvec-ai/zvec-grep";
    changelog = "https://github.com/zvec-ai/zvec-grep/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ moraxyc ];
    mainProgram = "zg";
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryNativeCode
    ];
    # @zvec/zvec publishes native bindings for these Linux architectures.
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
})

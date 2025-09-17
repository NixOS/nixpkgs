{
  fetchgit,
  git,
  lib,
  stdenv,
  versionCheckHook,
  virgil3,
  which,
}:

stdenv.mkDerivation {
  pname = "wizard-engine";
  version = "25β.2841";

  src = fetchgit {
    url = "https://github.com/titzer/wizard-engine.git";
    rev = "a416323a13277cf6807464d6b917700e2207bc53";
    hash = "sha256-dP28uVXTnIiKKZeXFVDrU2C2IyPc7BkqMTco03eyIOk=";
    # We need the full .git history here because the project's build.sh script
    # uses Git to compute the minor version number.
    deepClone = true;
    leaveDotGit = true;
  };

  postPatch = ''
    patchShebangs .
  '';

  nativeBuildInputs = [
    git
    virgil3
    which
  ];

  # The default target also tries to build for Java, which we don't want here.
  makeFlags = [ "x86-64-linux" ];

  installPhase = ''
    mkdir -p $out/bin
    mv bin/wizeng.x86-64-linux $out/bin/wizeng
  '';

  # Allowing the default fixup phase to run causes the final binary to segfault.
  fixupPhase = ''
    :
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Research WebAssembly Engine";
    homepage = "https://github.com/titzer/wizard-engine";
    license = lib.licenses.asl20;
    mainProgram = "wizeng";
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ samestep ];
  };
}

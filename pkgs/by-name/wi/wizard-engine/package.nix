{
  fetchFromGitHub,
  jdk,
  lib,
  makeWrapper,
  stdenv,
  versionCheckHook,
  virgil3,
  which,
}:

stdenv.mkDerivation {
  pname = "wizard-engine";
  version = "25β.2881";

  src = fetchFromGitHub {
    owner = "titzer";
    repo = "wizard-engine";
    rev = "06338ec23bbcd877c3a3f6913389c9e7bf74645e";
    # We need the full .git history here to mimic the behavior of the project's
    # build.sh script which uses Git to compute the minor version number.
    deepClone = true;
    leaveDotGit = true;
    postFetch = ''
      cd $out
      git rev-list --count HEAD > REVS
      rm -rf .git
    '';
    hash = "sha256-N999o8iZ8ik4mceiXmGLBK7lJlWhidoP44+5iEx7OOg=";
  };

  patches = [ ./revs.patch ];

  postPatch = ''
    patchShebangs .
  '';

  nativeBuildInputs = [
    jdk
    makeWrapper
    virgil3
    which
  ];

  installPhase =
    if (stdenv.hostPlatform.system == "x86_64-linux") then
      ''
        runHook preInstall
        mkdir -p $out/bin
        mv bin/wizeng.x86-64-linux $out/bin/wizeng
        runHook postInstall
      ''
    else
      ''
        runHook preInstall
        mkdir -p $out/bin
        mv bin/wizeng.jvm.jar $out/bin/wizeng.jvm.jar
        mv bin/wizeng.jvm $out/bin/wizeng
        runHook postInstall
      '';

  # Allowing the default fixup phase to run causes the x86 binary to segfault.
  fixupPhase = ''
    runHook preFixup
    runHook postFixup
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Research WebAssembly Engine";
    homepage = "https://github.com/titzer/wizard-engine";
    license = lib.licenses.asl20;
    mainProgram = "wizeng";
    maintainers = with lib.maintainers; [ samestep ];
  };
}

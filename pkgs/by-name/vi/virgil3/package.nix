{
  coreutils,
  fetchFromGitHub,
  jdk,
  lib,
  makeWrapper,
  stdenv,
  versionCheckHook,
  which,
}:

stdenv.mkDerivation {
  # We put the major version number 3 in the package name instead of the version
  # because it also appears in the *.v3 file extension for source files, as well
  # as the compiler binary name v3c. Also, the version reported by the compiler
  # itself is "Aeneas III-9.*" which wouldn't match unless we spelled it with
  # Roman numerals here too, but we're not allowed to do that anyway.
  pname = "virgil3";
  version = "9.1864";

  src = fetchFromGitHub {
    owner = "titzer";
    repo = "virgil";
    rev = "0c28b4ed11d205cfc366673da6338ebd7518a11b";
    hash = "sha256-79GzGqiPprCwrJINLmN0dG2qMUXZXqawWsMPT7fR96M=";
  };

  postPatch = ''
    patchShebangs .
  '';

  # Needed for bootstrapping.
  preConfigure = ''
    export PATH=$PWD/bin:$PATH
  '';

  nativeBuildInputs = [
    jdk
    makeWrapper
    which
  ];

  # The bin/v3c file in the source repository is a shell script, but that file
  # is also in .gitignore and gets overwritten during the build to instead be a
  # symlink pointing to one of the Aeneas binaries under bin/current depending
  # on the detected platform.
  installPhase =
    let
      path = lib.makeBinPath [
        coreutils
        jdk
      ];
    in
    ''
      runHook preInstall
      mkdir -p $out/bin
      if [ -f bin/Aeneas.jar ]; then
        mv $(readlink bin/Aeneas.jar) $out/bin/Aeneas.jar
      fi
      mv $(readlink bin/v3c) $out/bin/v3c
      mv bin/v3c-* $out/bin/
      mv lib $out/lib
      mv rt $out/rt
      wrapProgram $out/bin/v3c --prefix PATH : ${path}
      wrapProgram $out/bin/v3c-jar --prefix PATH : ${path}
      runHook postInstall
    '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Fast and lightweight native programming language";
    homepage = "https://github.com/titzer/virgil";
    license = lib.licenses.asl20;
    mainProgram = "v3c";
    maintainers = with lib.maintainers; [ samestep ];
  };
}

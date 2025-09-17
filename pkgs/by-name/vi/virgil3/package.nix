{
  fetchFromGitHub,
  lib,
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
    rev = "c4580692161bf81f71fd4d6c83db295157d74607";
    hash = "sha256-uSayFzSu8cB0btdyxUAmNEJiSyqfGu/UMImLTUMsAzA=";
  };

  postPatch = ''
    patchShebangs .
  '';

  # Needed for bootstrapping.
  preConfigure = ''
    export PATH=$PWD/bin:$PATH
  '';

  nativeBuildInputs = [
    which
  ];

  # The bin/v3c file in the source repository is a shell script, but that file
  # is also in .gitignore and gets overwritten during the build to instead be a
  # symlink pointing to one of the Aeneas binaries under bin/current depending
  # on the detected platform.
  installPhase = ''
    mkdir -p $out/bin
    mv $(readlink bin/v3c) $out/bin/v3c
    mv bin/v3c-x86-64-linux $out/bin/v3c-x86-64-linux
    mv bin/v3c-x86-linux $out/bin/v3c-x86-linux
    mv lib $out/lib
    mv rt $out/rt
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Fast and lightweight native programming language";
    homepage = "https://github.com/titzer/virgil";
    license = lib.licenses.asl20;
    mainProgram = "v3c";
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ samestep ];
  };
}

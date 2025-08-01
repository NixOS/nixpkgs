{
  mkDerivation,
}:

mkDerivation {
  pname = "breeze-grub";
  installPhase = ''
    runHook preInstall

    mkdir -p "$out/grub/themes"
    mv breeze "$out/grub/themes"

    runHook postInstall
  '';
}

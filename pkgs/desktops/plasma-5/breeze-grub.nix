{
  mkDerivation
}:

mkDerivation {
  name = "breeze-grub";
  installPhase = ''
    runHook preInstall

    mkdir -p "$out/grub/themes"
    mv breeze "$out/grub/themes"

    runHook postInstall
  '';
}

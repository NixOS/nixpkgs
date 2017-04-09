{
  plasmaPackage
}:

plasmaPackage {
  name = "breeze-grub";
  outputs = [ "out" ];
  installPhase = ''
    runHook preInstall

    mkdir -p "$out/grub/themes"
    mv breeze "$out/grub/themes"

    runHook postInstall
  '';
}

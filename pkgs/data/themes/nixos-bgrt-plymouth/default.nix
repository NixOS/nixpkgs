{
  lib,
  stdenv,
  fetchFromGitHub,
  unstableGitUpdater,
}:

stdenv.mkDerivation {
  name = "nixos-bgrt-plymouth";
  version = "0-unstable-2023-03-10";

  src = fetchFromGitHub {
    repo = "plymouth-theme-nixos-bgrt";
    owner = "helsinki-systems";
    rev = "0771e04f13b6b908d815b506472afb1c9a2c81ae";
    hash = "sha256-aF4Ro5z4G6LS40ENwFDH8CgV7ldfhzqekuSph/DMQoo=";
  };

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/plymouth/themes/nixos-bgrt
    cp -r $src/{*.plymouth,images} $out/share/plymouth/themes/nixos-bgrt/
    substituteInPlace $out/share/plymouth/themes/nixos-bgrt/*.plymouth --replace '@IMAGES@' "$out/share/plymouth/themes/nixos-bgrt/images"

    runHook postInstall
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = with lib; {
    description = "BGRT theme with a spinning NixOS logo";
    homepage = "https://github.com/helsinki-systems/plymouth-theme-nixos-bgrt";
    license = licenses.mit;
    maintainers = with maintainers; [ lilyinstarlight ];
    platforms = platforms.all;
  };
}

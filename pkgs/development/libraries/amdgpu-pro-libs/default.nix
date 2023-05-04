{ pkgs, lib, xorg, stdenv, openssl, libdrm, zlib, dpkg, patchelf }:

let
  ver = import ./version.nix { inherit pkgs; };
  suffix = ver.suffix;
  amdbit = ver.amdbit;
in
stdenv.mkDerivation rec {
  pname = "amdgpu-pro-vulkan${suffix}";
  version = ver.repo_folder_ver;


  pkg64 = builtins.fetchurl {
    url = "https://repo.radeon.com/amdgpu/${ver.repo_folder_ver}/ubuntu/pool/proprietary/v/vulkan-amdgpu-pro/vulkan-amdgpu-pro_${ver.major_short}-${ver.minor}.${ver.ubuntu_ver}_amd64.deb";
    sha256 = "sha256:02kavnxcccdrqz09v1628l005p1kzgv17wpqgb75nllyfr5103l9";
    name = "vulkan64";
  };
  pkg32 = builtins.fetchurl {
    url = "https://repo.radeon.com/amdgpu/${ver.repo_folder_ver}/ubuntu/pool/proprietary/v/vulkan-amdgpu-pro/vulkan-amdgpu-pro_${ver.major_short}-${ver.minor}.${ver.ubuntu_ver}_i386.deb";
    sha256 = "sha256:143r5vcqbh6s699w3y9wg87lnyl77h2g8kmdikcbl44y3q06xm6r";
    name = "vulkan32";
  };

  src = if stdenv.system == "x86_64-linux" then pkg64 else pkg32;

  dontPatchELF = true;
  sourceRoot = ".";
  nativeBuildInputs = [
    dpkg
    patchelf
  ];
  buildInputs = [
    libdrm
    openssl
    stdenv.cc.cc.lib
    xorg.libX11
    xorg.libxcb
    xorg.libxshmfence
    zlib
  ];
  rpath = lib.makeLibraryPath buildInputs;

  unpackPhase = ''
    dpkg -x  $src .
  '';

  installPhase = ''
    mkdir -p $out/lib
    mkdir -p $out/share/vulkan/icd.d
    install -Dm644   opt/amdgpu-pro/etc/vulkan/icd.d/amd_icd${suffix}.json $out/share/vulkan/icd.d/amd_pro_icd${suffix}.json
    install -Dm755   opt/amdgpu-pro/lib/${amdbit}/amdvlk${suffix}.so $out/lib/amdvlkpro${suffix}.so
    sed -i "s#/opt/amdgpu-pro/lib/${amdbit}/amdvlk${suffix}.so#$out/lib/amdvlkpro${suffix}.so#" $out/share/vulkan/icd.d/amd_pro_icd${suffix}.json
    patchelf --set-rpath "$rpath" $out/lib/amdvlkpro${suffix}.so
  '';

  meta = with lib; {
    description = "AMD Proprietary Driver For Vulkan";
    homepage = "https://www.amd.com";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" "i686-linux" ];
    maintainers = with maintainers; [ materus ];
  };
}

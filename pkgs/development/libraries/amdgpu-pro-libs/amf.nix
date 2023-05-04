{ pkgs, lib, stdenv, libdrm, dpkg, vulkan-loader, patchelf }:

let
  ver = import ./version.nix { inherit pkgs; };
  suffix = ver.suffix;
  amdbit = ver.amdbit;
in
stdenv.mkDerivation rec {
  pname = "amdgpu-pro-amf";
  version = ver.repo_folder_ver;



  src = [
    (builtins.fetchurl {
      url = "https://repo.radeon.com/amdgpu/${ver.repo_folder_ver}/ubuntu/pool/proprietary/a/amf-amdgpu-pro/amf-amdgpu-pro_${ver.amf}-${ver.minor}.${ver.ubuntu_ver}_amd64.deb";
      sha256 = "sha256:038d39lji5n85lg22mbxr7fq3nldwyrslkr5z94hp94g2l8ar5x5";
      name = "amf";
    })
    (builtins.fetchurl {
      url = "https://repo.radeon.com/amdgpu/${ver.repo_folder_ver}/ubuntu/pool/proprietary/liba/libamdenc-amdgpu-pro/libamdenc-amdgpu-pro_1.0-${ver.minor}.${ver.ubuntu_ver}_amd64.deb";
      sha256 = "sha256:0l0bfd2ayfhn15jk8cf8xnl2lgrcwpmc3c70qw3gf53jxrp5h0zs";
      name = "libamdenc";
    })
  ];


  dontPatchELF = true;
  sourceRoot = ".";
  nativeBuildInputs = [
    dpkg
    patchelf
  ];
  buildInputs = [
    vulkan-loader
    stdenv.cc.cc.lib
    libdrm
  ];
  rpath = lib.makeLibraryPath [
    vulkan-loader
    stdenv.cc.cc.lib
    libdrm
  ];
  unpackPhase = ''
    for file in $src; do dpkg -x $file .; done
  '';

  installPhase = ''
    mkdir -p $out
    mv opt/amdgpu-pro/lib/x86_64-linux-gnu $out/lib
    patchelf --set-rpath "$rpath" $out/lib/libamdenc64.so
    patchelf --set-rpath "$rpath" $out/lib/libamfrt64.so
  '';

  meta = with lib; {
    description = "AMD Advanced Multimedia Framework";
    homepage = "https://www.amd.com";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ materus ];
  };
}

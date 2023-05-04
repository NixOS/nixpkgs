{ pkgs, lib, systemd, xorg, mesa, stdenv, expat, openssl, libdrm, zlib, wayland, dpkg, patchelf }:

let
  ver = import ./version.nix { inherit pkgs; };
  suffix = ver.suffix;
  amdbit = ver.amdbit;
in
stdenv.mkDerivation rec {
  pname = "amdgpu-pro-opengl${suffix}";
  version = ver.repo_folder_ver;


  src64 = [
    #libgl
    (builtins.fetchurl {
      url = "https://repo.radeon.com/amdgpu/${ver.repo_folder_ver}/ubuntu/pool/proprietary/o/oglp-amdgpu-pro/libgl1-amdgpu-pro-oglp-dri_${ver.major_short}-${ver.minor}.${ver.ubuntu_ver}_amd64.deb";
      sha256 = "sha256:05ywwnscbfjd4jg76vfgq18zjymxph69hz58i2jn8gw6aqcpi36j";
      name = "libgl-dri64";
    })
    (builtins.fetchurl {
      url = "https://repo.radeon.com/amdgpu/${ver.repo_folder_ver}/ubuntu/pool/proprietary/o/oglp-amdgpu-pro/libgl1-amdgpu-pro-oglp-glx_${ver.major_short}-${ver.minor}.${ver.ubuntu_ver}_amd64.deb";
      sha256 = "sha256:0spad30ifhycll3jm5da4skxmv42v5kjkxc5cv0j719zqrnqrlj4";
      name = "libgl-glx64";
    })
    #egl
    (builtins.fetchurl {
      url = "https://repo.radeon.com/amdgpu/${ver.repo_folder_ver}/ubuntu/pool/proprietary/o/oglp-amdgpu-pro/libegl1-amdgpu-pro-oglp_${ver.major_short}-${ver.minor}.${ver.ubuntu_ver}_amd64.deb";
      sha256 = "sha256:1m4scayyw0w3cixpl3qb494bc7p0djby32g305r49g8zxp047msw";
      name = "libegl64";
    })
    #gles1
    (builtins.fetchurl {
      url = "https://repo.radeon.com/amdgpu/${ver.repo_folder_ver}/ubuntu/pool/proprietary/o/oglp-amdgpu-pro/libgles1-amdgpu-pro-oglp_${ver.major_short}-${ver.minor}.${ver.ubuntu_ver}_amd64.deb";
      sha256 = "sha256:0rkr6r7mx2zrp327wzg8jc41x0vgrhqsrlj51a78gqcxzyarfngk";
      name = "libgles1-64";
    })

    #gles2
    (builtins.fetchurl {
      url = "https://repo.radeon.com/amdgpu/${ver.repo_folder_ver}/ubuntu/pool/proprietary/o/oglp-amdgpu-pro/libgles2-amdgpu-pro-oglp_${ver.major_short}-${ver.minor}.${ver.ubuntu_ver}_amd64.deb";
      sha256 = "sha256:1rcc7xsag3gfszyz426bkk0ipbxazf6c2ws5zw2x8br2wdi2wq4x";
      name = "libgles2-64";
    })


  ];


  src32 = [
    #libgl
    (builtins.fetchurl {
      url = "https://repo.radeon.com/amdgpu/${ver.repo_folder_ver}/ubuntu/pool/proprietary/o/oglp-amdgpu-pro/libgl1-amdgpu-pro-oglp-dri_${ver.major_short}-${ver.minor}.${ver.ubuntu_ver}_i386.deb";
      sha256 = "sha256:1iak5yr2l3i5pvb2936xfknpm07zlqldjb4rnx7xy6n8w6aw1dhg";
      name = "libgl-dri32";
    })
    (builtins.fetchurl {
      url = "https://repo.radeon.com/amdgpu/${ver.repo_folder_ver}/ubuntu/pool/proprietary/o/oglp-amdgpu-pro/libgl1-amdgpu-pro-oglp-glx_${ver.major_short}-${ver.minor}.${ver.ubuntu_ver}_i386.deb";
      sha256 = "sha256:06iqjnw782fdc16j621k0cmhbnc7x6hn00qky3llz7p5ybnpk9vp";
      name = "libgl-glx32";
    })
    #egl
    (builtins.fetchurl {
      url = "https://repo.radeon.com/amdgpu/${ver.repo_folder_ver}/ubuntu/pool/proprietary/o/oglp-amdgpu-pro/libegl1-amdgpu-pro-oglp_${ver.major_short}-${ver.minor}.${ver.ubuntu_ver}_i386.deb";
      sha256 = "sha256:16574pgrm8946jfnyyfa9n6sjdjvvbp11kqjkfib3gjh9y3kmmw6";
      name = "libegl32";
    })
    #gles1
    (builtins.fetchurl {
      url = "https://repo.radeon.com/amdgpu/${ver.repo_folder_ver}/ubuntu/pool/proprietary/o/oglp-amdgpu-pro/libgles1-amdgpu-pro-oglp_${ver.major_short}-${ver.minor}.${ver.ubuntu_ver}_i386.deb";
      sha256 = "sha256:09pjxxgg7zjn5b61109va8w7xv5i3zdk627z92lpb4f48fy2i325";
      name = "libgles1-32";
    })

    #gles2
    (builtins.fetchurl {
      url = "https://repo.radeon.com/amdgpu/${ver.repo_folder_ver}/ubuntu/pool/proprietary/o/oglp-amdgpu-pro/libgles2-amdgpu-pro-oglp_${ver.major_short}-${ver.minor}.${ver.ubuntu_ver}_i386.deb";
      sha256 = "sha256:02w7lfl38xnw7gx90gpic6pf4xfm413k9ixp8qimsvn8irk8y45g";
      name = "libgles2-32";
    })
  ];
  src = if stdenv.system == "x86_64-linux" then src64 else src32;
  dontPatchELF = true;
  dontStrip = true;
  sourceRoot = ".";
  nativeBuildInputs = [
    dpkg
    patchelf
  ];
  buildInputs = [
    libdrm
    openssl
    expat
    stdenv.cc.cc.lib
    xorg.libX11
    xorg.libxcb
    xorg.libXext
    xorg.libXfixes
    xorg.libXxf86vm
    xorg.libxshmfence
    zlib
    wayland
    systemd
    mesa
  ];
  rpath = lib.makeLibraryPath buildInputs;
  unpackPhase = ''
    for file in $src; do dpkg -x $file .; done
  '';
  installPhase = ''
    mkdir $out
    mv opt/amdgpu/lib/${amdbit} $out/lib
    mv opt/amdgpu/share $out/share
    mv opt/amdgpu-pro/lib/${amdbit}/* $out/lib

    patchelf --set-rpath "$rpath" $out/lib/dri/amdgpu_dri.so
    for file in "$out/lib/*.so*"; do patchelf --set-rpath "$rpath" $file; done
  '';

  meta = with lib; {
    description = "AMD Proprietary Driver For OpenGL";
    homepage = "https://www.amd.com";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" "i686-linux" ];
    maintainers = with maintainers; [ materus ];
  };
}

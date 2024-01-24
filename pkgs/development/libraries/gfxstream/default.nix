{ lib, stdenv, fetchFromGitiles, meson, ninja, pkg-config, python3
, aemu, libdrm, libglvnd, vulkan-headers, vulkan-loader, xorg
}:

stdenv.mkDerivation {
  pname = "gfxstream";
  version = "0.1.2";

  src = fetchFromGitiles {
    url = "https://android.googlesource.com/platform/hardware/google/gfxstream";
    rev = "a29282666c0e2fdbb2c98cfe68a7c0677163ef91";
    hash = "sha256-IYXkaHZPEYIE9KW731GN6x6yRS+FYtP1zyHcaSofhIM=";
  };

  nativeBuildInputs = [ meson ninja pkg-config python3 ];
  buildInputs = [ aemu libglvnd vulkan-headers vulkan-loader xorg.libX11 ]
    ++ lib.optional (lib.meta.availableOn stdenv.hostPlatform libdrm) libdrm;

  # dlopens libvulkan.
  #
  # XXX: Unsure if this is required on Darwin.  If it is, it probably
  #      needs to be done using install_name_tool.
  preConfigure = lib.optionalString (!stdenv.isDarwin) ''
    mesonFlagsArray=(-Dcpp_link_args="-Wl,--push-state -Wl,--no-as-needed -lvulkan -Wl,--pop-state")
  '';

  meta = with lib; {
    homepage = "https://android.googlesource.com/platform/hardware/google/gfxstream";
    description = "Graphics Streaming Kit";
    license = licenses.free; # https://android.googlesource.com/platform/hardware/google/gfxstream/+/refs/heads/main/LICENSE
    maintainers = with maintainers; [ qyliss ];
    platforms = aemu.meta.platforms;
  };
}

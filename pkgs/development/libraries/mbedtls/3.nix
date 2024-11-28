{ callPackage, fetchurl }:

callPackage ./generic.nix {
  version = "3.6.2";
  hash = "sha256-tSWhF8i0Tx9QSFmyDEHdd2xveZvpyd+HXR+8xYj2Syo=";
  patches = [
    # Fixes the build with GCC 14.
    #
    # See:
    # * <https://github.com/openwrt/openwrt/pull/15479>
    # * <https://github.com/Mbed-TLS/mbedtls/issues/9003>
    (fetchurl {
      url = "https://raw.githubusercontent.com/openwrt/openwrt/52b6c9247997e51a97f13bb9e94749bc34e2d52e/package/libs/mbedtls/patches/100-fix-gcc14-build.patch";
      hash = "sha256-20bxGoUHkrOEungN3SamYKNgj95pM8IjbisNRh68Wlw=";
    })
  ];
}

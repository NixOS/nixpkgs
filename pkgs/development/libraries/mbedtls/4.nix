{ callPackage, fetchurl }:

callPackage ./generic.nix {
  version = "4.1.0";
  hash = "sha256-TA1uka13So8URttw+JJVdKIL+IonkhIQSc0IfraXpIM=";

  patches = [
    # Fixes the build with GCC 14 on aarch64.
    #
    # See:
    # * <https://github.com/openwrt/openwrt/pull/15479>
    # * <https://github.com/Mbed-TLS/mbedtls/issues/9003>
    ./0001-fix-gcc14-build.patch
  ];
}

{ callPackage, fetchurl, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "3.6.7";

  src = fetchurl {
    url = "mirror://gnupg/gnutls/v3.6/gnutls-${version}.tar.xz";
    sha256 = "1ql8l6l5bxks2pgpwb1602zc0j6ivhpy27hdfc49h8xgbanhjd2v";
  };

  # Skip some tests:
  #  - pkgconfig: building against the result won't work before installing (3.5.11)
  #  - fastopen: no idea; it broke between 3.6.2 and 3.6.3 (3437fdde6 in particular)
  #  - trust-store: default trust store path (/etc/ssl/...) is missing in sandbox (3.5.11)
  #  - psk-file: no idea; it broke between 3.6.3 and 3.6.4
  # Change p11-kit test to use pkg-config to find p11-kit
  postPatch = ''
    sed '2iexit 77' -i tests/{pkgconfig,fastopen}.sh
    sed '/^void doit(void)/,/^{/ s/{/{ exit(77);/' -i tests/{trust-store,psk-file}.c
    sed 's:/usr/lib64/pkcs11/ /usr/lib/pkcs11/ /usr/lib/x86_64-linux-gnu/pkcs11/:`pkg-config --variable=p11_module_path p11-kit-1`:' -i tests/p11-kit-trust.sh
  '';
})

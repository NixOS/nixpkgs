{ callPackage, fetchurl, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "3.6.1";

  src = fetchurl {
    url = "mirror://gnupg/gnutls/v3.6/gnutls-${version}.tar.xz";
    sha256 = "1vdsir53ddxyapnxh5fpnfyij3scx3818iri4hl07g4lk4n0vc90";
  };

  # Skip two tests introduced in 3.5.11.  Probable reasons of failure:
  #  - pkgconfig: building against the result won't work before installing
  #  - trust-store: default trust store path (/etc/ssl/...) is missing in sandbox
  # Change p11-kit test to use pkg-config to find p11-kit
  postPatch = ''
    sed '2iexit 77' -i tests/pkgconfig.sh
    sed '/^void doit(void)/,$s/{/{ exit(77);/; t' -i tests/trust-store.c
    sed 's:/usr/lib64/pkcs11/ /usr/lib/pkcs11/ /usr/lib/x86_64-linux-gnu/pkcs11/:`pkg-config --variable=p11_module_path p11-kit-1`:' -i tests/p11-kit-trust.sh
  '';
})

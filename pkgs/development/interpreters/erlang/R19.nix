{ mkDerivation, fetchurl, fetchpatch }:

mkDerivation rec {
  version = "19.3.6.4";
  sha256 = "1w0h3wj2h58m3jrfgw56xab2352na3i9ccrbpfs4420dn7igf071";

  patches = [
    # macOS 10.13 crypto fix from OTP-20.1.2
    (fetchpatch {
      name = "darwin-crypto.patch";
      url = "https://github.com/erlang/otp/commit/882c90f72ba4e298aa5a7796661c28053c540a96.patch";
      sha256 = "1gggzpm8ssamz6975z7px0g8qq5i4jqw81j846ikg49c5cxvi0hi";
    })
  ];

  prePatch = ''
    substituteInPlace configure.in --replace '`sw_vers -productVersion`' '10.10'
  '';
}

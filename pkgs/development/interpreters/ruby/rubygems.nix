{ stdenv, lib, fetchurl, fetchpatch }:

stdenv.mkDerivation rec {
  name = "rubygems";
  version = "2.7.7";

  src = fetchurl {
    url = "https://rubygems.org/rubygems/rubygems-${version}.tgz";
    sha256 = "1jsmmd31j8j066b83lin4bbqz19jhrirarzb41f3sjhfdjiwkcjc";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/zimbatm/rubygems/compare/v2.6.6...v2.6.6-nix.patch";
      sha256 = "0297rdb1m6v75q8665ry9id1s74p9305dv32l95ssf198liaihhd";
    })
  ];

  installPhase = ''
    runHook preInstall
    cp -r . $out
    runHook postInstall
  '';

  meta = with lib; {
    description = "Package management framework for Ruby";
    homepage = https://rubygems.org/;
    license = with licenses; [ mit /* or */ ruby ];
    maintainers = with maintainers; [ qyliss zimbatm ];
  };
}

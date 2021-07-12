{ stdenv, lib, fetchurl, fetchpatch }:

stdenv.mkDerivation rec {
  name = "rubygems";
  version = "3.2.16";

  src = fetchurl {
    url = "https://rubygems.org/rubygems/rubygems-${version}.tgz";
    sha256 = "1bpn45hchcbirqvqwxcxyk1xy2xkdd915jci2hfjq4y6zc4idns0";
  };

  patches = [
    ./0001-add-post-extract-hook.patch
    ./0002-binaries-with-env-shebang.patch
    ./0003-gem-install-default-to-user.patch
    # Ensure tmp directory are not left behind
    # https://github.com/rubygems/rubygems/pull/4610
    (fetchpatch {
      url = "https://github.com/rubygems/rubygems/commit/2c2ffde6e4a9f7f571d38af687034fb8507a833d.patch";
      sha256 = "sha256-bs2dXALKiJvMgk7lKjMx0NzGqlEqDYBBO35UrzNifms=";
    })
  ];

  installPhase = ''
    runHook preInstall
    cp -r . $out
    runHook postInstall
  '';

  meta = with lib; {
    description = "Package management framework for Ruby";
    homepage = "https://rubygems.org/";
    license = with licenses; [ mit /* or */ ruby ];
    maintainers = with maintainers; [ zimbatm ];
  };
}

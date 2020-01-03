{ stdenv, lib, fetchurl }:

stdenv.mkDerivation rec {
  name = "rubygems";
  version = "3.1.2";

  src = fetchurl {
    url = "https://rubygems.org/rubygems/rubygems-${version}.tgz";
    sha256 = "0h7ij4jpj8rgnpkl63cwh2lnav73pw5wpfqra3va7077lsyadlgd";
  };

  patches = [
    ./0001-add-post-extract-hook.patch
    ./0002-binaries-with-env-shebang.patch
    ./0003-gem-install-default-to-user.patch
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

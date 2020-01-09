{ stdenv, lib, fetchurl, fetchpatch }:

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

    (fetchpatch {
      url = "https://github.com/rubygems/rubygems/commit/0af4d2d369ff580ef54839ec15a8c7ec419978cb.patch";
      sha256 = "13gyfxn4rmxq1dbxq5rzphnhagn8n8kpp8lb9h6h4s9d4zaklax9";
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

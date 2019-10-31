{ stdenv, lib, fetchurl }:

stdenv.mkDerivation rec {
  name = "rubygems";
  version = "3.0.6";

  src = fetchurl {
    url = "https://rubygems.org/rubygems/rubygems-${version}.tgz";
    sha256 = "1ca1i4xmggizr59m6p28gprlvshczsbx30q8iyzxb2vj4jn8arzx";
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

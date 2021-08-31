{ stdenv, lib, fetchurl }:

stdenv.mkDerivation rec {
  name = "rubygems";
  version = "3.2.24";

  src = fetchurl {
    url = "https://rubygems.org/rubygems/rubygems-${version}.tgz";
    sha256 = "09ff830a043y6s7390hsg3k55ffpifb1zsvs0dhz8z8pypwgiscl";
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
    homepage = "https://rubygems.org/";
    license = with licenses; [ mit /* or */ ruby ];
    maintainers = with maintainers; [ zimbatm ];
  };
}

{ stdenv, fetchFromGitHub, fetchpatch, premake4 }:

stdenv.mkDerivation rec {
  name = "bootil-unstable-2015-12-17";

  meta = {
    description = "Garry Newman's personal utility library";
    homepage = https://github.com/garrynewman/bootil;
    # License unsure - see https://github.com/garrynewman/bootil/issues/21
    license = stdenv.lib.licenses.free;
    maintainers = [ stdenv.lib.maintainers.abigailbuccaneer ];
    platforms = stdenv.lib.platforms.all;
    # Build uses `-msse` and `-mfpmath=sse`
    badPlatforms = [ "aarch64-linux" ];
  };

  src = fetchFromGitHub {
    owner = "garrynewman";
    repo = "bootil";
    rev = "1d3e321fc2be359e2350205b8c7f1cad2164ee0b";
    sha256 = "03wq526r80l2px797hd0n5m224a6jibwipcbsvps6l9h740xabzg";
  };

  patches = [ (fetchpatch {
    url = https://github.com/garrynewman/bootil/pull/22.patch;
    name = "github-pull-request-22.patch";
    sha256 = "1qf8wkv00pb9w1aa0dl89c8gm4rmzkxfl7hidj4gz0wpy7a24qa2";
  }) ];

  # Avoid guessing where files end up. Just use current directory.
  postPatch = ''
    substituteInPlace projects/premake4.lua \
      --replace 'location ( os.get() .. "/" .. _ACTION )' 'location ( ".." )'
    substituteInPlace projects/bootil.lua \
      --replace 'targetdir ( "../lib/" .. os.get() .. "/" .. _ACTION )' 'targetdir ( ".." )'
  '';

  nativeBuildInputs = [ premake4 ];
  premakefile = "projects/premake4.lua";

  installPhase = ''
    install -D libbootil_static.a $out/lib/libbootil_static.a
    cp -r include $out
  '';
}

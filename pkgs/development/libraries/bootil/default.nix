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
  })];

  platform =
    if stdenv.isLinux then "linux"
    else if stdenv.isDarwin then "macosx"
    else throw "unrecognized system ${stdenv.system}";

  buildInputs = [ premake4 ];

  configurePhase = "premake4 --file=projects/premake4.lua gmake";
  makeFlags = "-C projects/${platform}/gmake";

  installPhase = ''
    mkdir -p $out/lib
    cp lib/${platform}/gmake/libbootil_static.a $out/lib/
    cp -r include $out/
  '';
}

{
  stdenv,
  pkgsHostTarget,
  cmake,
  makeWrapper,
  fetchpatch,
  mkDerivation,
  fetchFromGitHub,
  alex,
  lib,
  hpack,
  aeson,
  array,
  async,
  base,
  bytestring,
  co-log-core,
  cond,
  containers,
  directory,
  FloatingHex,
  isocline,
  lens,
  lsp,
  mtl,
  network,
  network-simple,
  parsec,
  process,
  text,
  text-rope,
  time,
}:

let
  version = "3.1.0";
  src = fetchFromGitHub {
    owner = "koka-lang";
    repo = "koka";
    rev = "v${version}";
    sha256 = "sha256-Twm2Hr8BQ0xTdA30e2Az/57525jTUkmv2Zs/+SNiQns=";
    fetchSubmodules = true;
  };
  kklib = stdenv.mkDerivation {
    pname = "kklib";
    inherit version;
    src = "${src}/kklib";
    nativeBuildInputs = [ cmake ];
    outputs = [
      "out"
      "dev"
    ];
    postInstall = ''
      mkdir -p ''${!outputDev}/share/koka/v${version}
      cp -a ../../kklib ''${!outputDev}/share/koka/v${version}
    '';
  };
  inherit (pkgsHostTarget.targetPackages.stdenv) cc;
  runtimeDeps = [
    cc
    cc.bintools.bintools
    pkgsHostTarget.gnumake
    pkgsHostTarget.cmake
  ];
in
mkDerivation rec {
  pname = "koka";
  inherit version src;
  isLibrary = false;
  isExecutable = true;
  libraryToolDepends = [ hpack ];
  patches = [
    (fetchpatch {
      name = "koka-stackage-22.patch";
      url = "https://github.com/koka-lang/koka/commit/95f9b360544996e06d4bb33321a83a6b9605d092.patch";
      sha256 = "1a1sv1r393wkhsnj56awsi8mqxakqdy86p7dg9i9xfv13q2g4h6x";
      includes = [ "src/**" ];
    })
  ];
  executableHaskellDepends = [
    aeson
    array
    async
    base
    bytestring
    co-log-core
    cond
    containers
    directory
    FloatingHex
    isocline
    lens
    lsp
    mtl
    network
    network-simple
    parsec
    process
    text
    text-rope
    time
    kklib
  ];
  executableToolDepends = [
    alex
    makeWrapper
  ];
  postInstall = ''
    mkdir -p $out/share/koka/v${version}
    cp -a lib $out/share/koka/v${version}
    ln -s ${kklib.dev}/share/koka/v${version}/kklib $out/share/koka/v${version}
    wrapProgram "$out/bin/koka" \
      --set CC "${lib.getBin cc}/bin/${cc.targetPrefix}cc" \
      --prefix PATH : "${lib.makeSearchPath "bin" runtimeDeps}"
  '';
  doCheck = false;
  prePatch = "hpack";
  description = "Koka language compiler and interpreter";
  homepage = "https://github.com/koka-lang/koka";
  changelog = "${homepage}/blob/master/doc/spec/news.mdk";
  license = lib.licenses.asl20;
  maintainers = with lib.maintainers; [
    siraben
    sternenseemann
  ];
}

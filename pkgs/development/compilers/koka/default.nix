{ stdenv, buildPackages, cmake, gnumake, makeWrapper, mkDerivation, fetchFromGitHub
, alex, array, base, bytestring, cond, containers, directory, extra
, filepath, haskeline, hpack, hspec, hspec-core, json, lib, mtl
, parsec, process, regex-compat, text, time }:

let
  version = "2.1.1";
  src = fetchFromGitHub {
    owner = "koka-lang";
    repo = "koka";
    rev = "v${version}";
    sha256 = "sha256-cq+dljfTKJh5NgwQfxQQP9jRcg2PQxxBVEgQ59ll36o=";
    fetchSubmodules = true;
  };
  kklib = stdenv.mkDerivation {
    pname = "kklib";
    inherit version;
    src = "${src}/kklib";
    nativeBuildInputs = [ cmake ];
  };
  runtimeDeps = [
    buildPackages.stdenv.cc
    buildPackages.stdenv.cc.bintools.bintools
    gnumake
    cmake
  ];
in
mkDerivation rec {
  pname = "koka";
  inherit version src;
  isLibrary = false;
  isExecutable = true;
  libraryToolDepends = [ hpack ];
  executableHaskellDepends = [
    array base bytestring cond containers directory haskeline mtl
    parsec process text time kklib
  ];
  executableToolDepends = [ alex makeWrapper ];
  postInstall = ''
    mkdir -p $out/share/koka/v${version}
    cp -a lib $out/share/koka/v${version}
    cp -a contrib $out/share/koka/v${version}
    cp -a kklib $out/share/koka/v${version}
    wrapProgram "$out/bin/koka" \
      --set CC "${lib.getBin buildPackages.stdenv.cc}/bin/${buildPackages.stdenv.cc.targetPrefix}cc" \
      --prefix PATH : "${lib.makeSearchPath "bin" runtimeDeps}"
  '';
  doCheck = false;
  prePatch = "hpack";
  description = "Koka language compiler and interpreter";
  homepage = "https://github.com/koka-lang/koka";
  license = lib.licenses.asl20;
  maintainers = with lib.maintainers; [ siraben sternenseemann ];
}

{ stdenv, pkgsHostTarget, cmake, makeWrapper, mkDerivation, fetchFromGitHub
, alex, array, base, bytestring, cond, containers, directory, extra
, filepath, hpack, hspec, hspec-core, isocline, json, lib, mtl
, parsec, process, regex-compat, text, time }:

let
  version = "2.3.2";
  src = fetchFromGitHub {
    owner = "koka-lang";
    repo = "koka";
    rev = "v${version}";
    sha256 = "sha256-+w99Jvsd1tccUUYaP2TRgCNyGnMINWamuNRumHGzFWA=";
    fetchSubmodules = true;
  };
  kklib = stdenv.mkDerivation {
    pname = "kklib";
    inherit version;
    src = "${src}/kklib";
    nativeBuildInputs = [ cmake ];
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
  executableHaskellDepends = [
    array base bytestring cond containers directory isocline mtl
    parsec process text time kklib
  ];
  executableToolDepends = [ alex makeWrapper ];
  postInstall = ''
    mkdir -p $out/share/koka/v${version}
    cp -a lib $out/share/koka/v${version}
    cp -a kklib $out/share/koka/v${version}
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
  maintainers = with lib.maintainers; [ siraben sternenseemann ];
}

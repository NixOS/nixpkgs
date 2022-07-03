{ lib, stdenv, fetchurl, curl, tzdata, autoPatchelfHook, fixDarwinDylibNames, glibc
, version, hashes }:

let
  inherit (stdenv) hostPlatform;
  OS = if hostPlatform.isDarwin then "osx" else hostPlatform.parsed.kernel.name;
  MODEL = toString hostPlatform.parsed.cpu.bits;
in stdenv.mkDerivation {
  pname = "dmd-bootstrap";
  inherit version;

  src = fetchurl rec {
    name = "dmd.${version}.${OS}.tar.xz";
    url = "http://downloads.dlang.org/releases/2.x/${version}/${name}";
    sha256 = hashes.${OS} or (throw "missing bootstrap sha256 for OS ${OS}");
  };

  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = lib.optionals hostPlatform.isLinux [
    autoPatchelfHook
  ] ++ lib.optional hostPlatform.isDarwin fixDarwinDylibNames;
  propagatedBuildInputs = [ curl tzdata ] ++ lib.optional hostPlatform.isLinux glibc;

  installPhase = ''
    mkdir -p $out

    # try to copy model-specific binaries into bin first
    mv ${OS}/bin${MODEL} $out/bin || true

    mv src license.txt ${OS}/* $out/

    # move man into place
    mkdir -p $out/share
    mv man $out/share/

    # move docs into place
    mkdir -p $out/share/doc
    mv html/d $out/share/doc/

    # fix paths in dmd.conf (one level less)
    substituteInPlace $out/bin/dmd.conf --replace "/../../" "/../"
  '';

  meta = with lib; {
    description = "Digital Mars D Compiler Package";
    # As of 2.075 all sources and binaries use the boost license
    license = licenses.boost;
    maintainers = [ maintainers.lionello ];
    homepage = "https://dlang.org/";
    platforms = [ "x86_64-darwin" "i686-linux" "x86_64-linux" ];
  };
}

{ lib, stdenv, fetchurl, curl, tzdata, autoPatchelfHook, fixDarwinDylibNames, libxml2
, version, hashes }:

let
  inherit (stdenv) hostPlatform;
  OS = if hostPlatform.isDarwin then "osx" else hostPlatform.parsed.kernel.name;
  ARCH = if hostPlatform.isDarwin && hostPlatform.isAarch64 then "arm64" else hostPlatform.parsed.cpu.name;
in stdenv.mkDerivation {
  pname = "ldc-bootstrap";
  inherit version;

  src = fetchurl rec {
    name = "ldc2-${version}-${OS}-${ARCH}.tar.xz";
    url = "https://github.com/ldc-developers/ldc/releases/download/v${version}/${name}";
    sha256 = hashes."${OS}-${ARCH}" or (throw "missing bootstrap sha256 for ${OS}-${ARCH}");
  };

  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = lib.optionals hostPlatform.isLinux [
    autoPatchelfHook
  ] ++ lib.optional hostPlatform.isDarwin fixDarwinDylibNames;

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ libxml2 stdenv.cc.cc ];

  propagatedBuildInputs = [ curl tzdata ];

  installPhase = ''
    mkdir -p $out

    mv bin etc import lib LICENSE README $out/
  '';

  meta = with lib; {
    description = "The LLVM-based D Compiler";
    homepage = "https://github.com/ldc-developers/ldc";
    # from https://github.com/ldc-developers/ldc/blob/master/LICENSE
    license = with licenses; [ bsd3 boost mit ncsa gpl2Plus ];
    maintainers = with maintainers; [ ThomasMader lionello ];
    platforms = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];
  };
}

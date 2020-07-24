{ stdenv, fetchurl, curl, tzdata, autoPatchelfHook, fixDarwinDylibNames, libxml2
, version, hashes }:
with stdenv;
let
  OS = if hostPlatform.isDarwin then "osx" else hostPlatform.parsed.kernel.name;
  ARCH = toString hostPlatform.parsed.cpu.name;
in mkDerivation {
  pname = "ldc-bootstrap";
  inherit version;

  src = fetchurl rec {
    name = "ldc2-${version}-${OS}-${ARCH}.tar.xz";
    url = "https://github.com/ldc-developers/ldc/releases/download/v${version}/${name}";
    sha256 = hashes."${OS}-${ARCH}" or (throw "missing bootstrap sha256 for ${OS}-${ARCH}");
  };

  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = [ fixDarwinDylibNames autoPatchelfHook ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ libxml2 stdenv.cc.cc ];

  propagatedBuildInputs = [ curl tzdata ];

  installPhase = ''
    mkdir -p $out

    mv bin etc import lib LICENSE README $out/
  '';

  meta = with lib; {
    inherit version;
    description = "The LLVM-based D Compiler";
    homepage = "https://github.com/ldc-developers/ldc";
    # from https://github.com/ldc-developers/ldc/blob/master/LICENSE
    license = with licenses; [ bsd3 boost mit ncsa gpl2Plus ];
    maintainers = with maintainers; [ ThomasMader lionello ];
    platforms = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" ];
  };
}

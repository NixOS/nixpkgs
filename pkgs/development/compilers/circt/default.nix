{ stdenv
, lib
, cmake
, coreutils
, python3
, git
, fetchFromGitHub
, ninja
}:

let
  pythonEnv = python3.withPackages (ps: [ ps.psutil ]);
in
stdenv.mkDerivation rec {
  pname = "circt";
  version = "1.29.0";
  src = fetchFromGitHub {
    owner = "llvm";
    repo = "circt";
    rev = "firtool-${version}";
    sha256 = "sha256-HsXwh98RZuXvK/KkZ2NAGwWNLxUAQVj+WKzZXd4C4Is=";
    fetchSubmodules = true;
  };

  requiredSystemFeatures = [ "big-parallel" ];

  nativeBuildInputs = [ cmake ninja git pythonEnv ];

  cmakeDir = "../llvm/llvm";
  cmakeFlags = [
    "-DLLVM_ENABLE_BINDINGS=OFF"
    "-DLLVM_ENABLE_OCAMLDOC=OFF"
    "-DLLVM_BUILD_EXAMPLES=OFF"
    "-DLLVM_OPTIMIZED_TABLEGEN=ON"
    "-DLLVM_ENABLE_PROJECTS=mlir"
    "-DLLVM_EXTERNAL_PROJECTS=circt"
    "-DLLVM_EXTERNAL_CIRCT_SOURCE_DIR=.."
    "-DCIRCT_LLHD_SIM_ENABLED=OFF"
  ];

  preConfigure = ''
    substituteInPlace test/circt-reduce/test/annotation-remover.mlir --replace "/usr/bin/env" "${coreutils}/bin/env"
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    mv bin/{{fir,hls}tool,circt-{as,dis,lsp-server,opt,reduce,translate}} $out/bin
    runHook postInstall
  '';

  doCheck = true;
  checkTarget = "check-circt check-circt-integration";

  meta = {
    description = "Circuit IR compilers and tools";
    homepage = "https://circt.org/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ sharzy ];
    platforms = lib.platforms.all;
  };
}


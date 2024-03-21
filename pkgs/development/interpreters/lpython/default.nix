{ lib
, fetchFromGitHub
, cmake
, stdenv
, bison
, llvmPackages
, python3
, rapidjson
, re2c
, zlib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lpython";
  version = "0.19.0";

  src = fetchFromGitHub {
    owner = "lcompilers";
    repo = "lpython";
    rev = "v${finalAttrs.version}";
    hash = "sha256-mT/RkeDhJg2EP5QzimWDL43xaY57/DBaJeWLpiLvesg=";
  };

  postPatch = ''
    substituteInPlace build0.sh --replace "ci/version.sh" "echo ${finalAttrs.version} > version"
  '';

  cmakeFlags = [
    "-DLPYTHON_BUILD_ALL=ON"
    "-DWITH_FMT=ON"
    "-DWITH_JSON=ON"
    "-DWITH_LLVM=ON"
    "-DWITH_LSP=ON"
  ] ++ lib.optionals (stdenv.isLinux) [ "-DZLIB_LIBRARY=${zlib}/lib/libz.so" ];

  preConfigure = ''
    sh build0.sh
  '';

  buildInputs = [
    zlib
    rapidjson
  ];

  nativeBuildInputs = [
    bison
    cmake
    llvmPackages.llvm
    python3
    re2c
  ];

  doCheck = true;

  meta = {
    description = "High performance typed Python compiler";
    homepage = "https://lpython.org";
    license = lib.licenses.bsd3;
    mainProgram = "lpython";
    maintainers = with lib.maintainers; [ dit7ya ];
  };
})

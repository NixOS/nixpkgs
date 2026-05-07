{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  llvmPackages,
  enableOpenMP ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wfa2-lib";
  version = "2.3.5";

  src = fetchFromGitHub {
    owner = "smarco";
    repo = "WFA2-lib";
    rev = "v${finalAttrs.version}";
    hash = "sha256-vTeSvhSt3PQ/BID6uM1CuXkQipgG7VViDexvAwV4nW8=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = lib.optionals enableOpenMP [ llvmPackages.openmp ];

  cmakeFlags = [ "-DOPENMP=${if enableOpenMP then "ON" else "OFF"}" ];

  meta = {
    description = "Wavefront alignment algorithm library v2";
    homepage = "https://github.com/smarco/WFA2-lib";
    license = lib.licenses.mit;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})

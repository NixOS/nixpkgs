{ lib
, stdenv
, fetchFromGitHub
, rocmUpdateScript
, substituteAll
, llvm
, rocm-runtime
, rocminfo
, lsb-release
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hip-common";
  version = "5.7.0";

  src = fetchFromGitHub {
    owner = "ROCm-Developer-Tools";
    repo = "HIP";
    rev = "rocm-${finalAttrs.version}";
    hash = "sha256-1Abit9qZCwrCVcnaFT4uMygFB9G6ovRasLmTsOsJ/Fw=";
  };

  patches = [
    (substituteAll {
      src = ./0000-fixup-paths.patch;
      inherit llvm rocminfo;
      clang = stdenv.cc;
      rocm_runtime = rocm-runtime;
      lsb_release = lsb-release;
    })
  ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    mv * $out

    runHook postInstall
  '';

  passthru.updateScript = rocmUpdateScript {
    name = finalAttrs.pname;
    owner = finalAttrs.src.owner;
    repo = finalAttrs.src.repo;
  };

  meta = with lib; {
    description = "C++ Heterogeneous-Compute Interface for Portability";
    homepage = "https://github.com/ROCm-Developer-Tools/HIP";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ lovesegfault ] ++ teams.rocm.members;
    platforms = platforms.linux;
    broken = versions.minor finalAttrs.version != versions.minor stdenv.cc.version;
  };
})

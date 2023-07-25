{ lib
, stdenv
, fetchFromGitHub
, rocmUpdateScript
, substituteAll
, cmake
, llvm
, rocm-runtime
, rocminfo
, lsb-release
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hipcc";
  version = "5.4.2";

  src = fetchFromGitHub {
    owner = "ROCm-Developer-Tools";
    repo = "HIPCC";
    rev = "rocm-${finalAttrs.version}";
    hash = "sha256-PEwue4O43MiMkF8UmTeHsmlikBG2V3/nFQLKmtHrRWQ=";
  };

  patches = [
    (substituteAll {
      src = ./0000-fixup-paths.patch;
      inherit llvm rocminfo;
      version_major = lib.versions.major finalAttrs.version;
      version_minor = lib.versions.minor finalAttrs.version;
      version_patch = lib.versions.patch finalAttrs.version;
      clang = stdenv.cc;
      rocm_runtime = rocm-runtime;
      lsb_release = lsb-release;
    })
  ];

  nativeBuildInputs = [ cmake ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    mv *.bin $out/bin

    runHook postInstall
  '';

  passthru.updateScript = rocmUpdateScript {
    name = finalAttrs.pname;
    owner = finalAttrs.src.owner;
    repo = finalAttrs.src.repo;
  };

  meta = with lib; {
    description = "Compiler driver utility that calls clang or nvcc";
    homepage = "https://github.com/ROCm-Developer-Tools/HIPCC";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ lovesegfault ] ++ teams.rocm.members;
    platforms = platforms.linux;
    broken = versions.minor finalAttrs.version != versions.minor stdenv.cc.version;
  };
})

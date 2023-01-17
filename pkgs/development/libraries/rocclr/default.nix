{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, rocmUpdateScript
, rocm-comgr
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rocclr";
  version = "5.4.2";

  src = fetchFromGitHub {
    owner = "ROCm-Developer-Tools";
    repo = "ROCclr";
    rev = "rocm-${finalAttrs.version}";
    hash = "sha256-tYFoGafOsJYnRQaOLAaFix6tPD0QPTidOtOicPxP2Vk=";
  };

  patches = [
    # Enable support for gfx8 again
    # See the upstream issue: https://github.com/RadeonOpenCompute/ROCm/issues/1659
    # And the arch patch: https://github.com/rocm-arch/rocm-arch/pull/742
    (fetchpatch {
      url = "https://raw.githubusercontent.com/John-Gee/rocm-arch/d6812d308fee3caf2b6bb01b4d19fe03a6a0e3bd/rocm-opencl-runtime/enable-gfx800.patch";
      hash = "sha256-59jFDIIsTTZcNns9RyMVWPRUggn/bSlAGrky4quu8B4=";
    })
  ];

  postPatch = ''
    substituteInPlace device/comgrctx.cpp \
      --replace "libamd_comgr.so" "${rocm-comgr}/lib/libamd_comgr.so"
  '';

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -a * $out/

    runHook postInstall
  '';

  passthru.updateScript = rocmUpdateScript {
    name = finalAttrs.pname;
    owner = finalAttrs.src.owner;
    repo = finalAttrs.src.repo;
  };

  meta = with lib; {
    description = "Source package of the Radeon Open Compute common language runtime";
    homepage = "https://github.com/ROCm-Developer-Tools/ROCclr";
    license = licenses.mit;
    maintainers = with maintainers; [ lovesegfault ] ++ teams.rocm.members;
    # rocclr seems to have some AArch64 ifdefs, but does not seem
    # to be supported yet by the build infrastructure. Recheck in
    # the future.
    platforms = [ "x86_64-linux" ];
    broken = finalAttrs.version != stdenv.cc.version;
  };
})

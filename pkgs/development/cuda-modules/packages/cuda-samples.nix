{
  autoAddDriverRunpath,
  backendStdenv,
  cmake,
  cudaFlags,
  cudatoolkit-legacy-runfile,
  cudaMajorMinorVersion,
  cudaMajorMinorPatchVersion,
  fetchFromGitHub,
  fetchpatch,
  freeimage,
  glfw3,
  lib,
  pkg-config,
  stdenv,
}:
let
  inherit (lib)
    attrsets
    lists
    misc
    trivial
    strings
    ;
  inherit (stdenv) hostPlatform;

  cudaVersionToHash = {
    "10.0" = "sha256-XAI6iiPpDVbZtFoRaP1s6VKpu9aV3bwOqqkw33QncP8=";
    "10.1" = "sha256-DY8E2FKCFj27jPgQEB1qE9HcLn7CfSiVGdFm+yFQE+k=";
    "10.2" = "sha256-JDW4i7rC2MwIRvKRmUd6UyJZI9bWNHqZijrB962N4QY=";
    "11.0" = "sha256-BRwQuUvJEVi1mTbVtGODH8Obt7rXFfq6eLH9wxCTe9g=";
    "11.1" = "sha256-kM8gFItBaTpkoT34vercmQky9qTFtsXjXMGjCMrsUc4=";
    "11.2" = "sha256-gX6V98dRwdAQIsvru2byDLiMswCW2lrHSBSJutyWONw=";
    "11.3" = "sha256-34MdMFS2cufNbZVixFdSUDFfLeuKIGFwLBL9d81acU0=";
    "11.4" = "sha256-Ewu+Qk6GtGXC37CCn1ZXHc0MQAuyXCGf3J6T4cucTSA=";
    "11.5" = "sha256-AKRZbke0K59lakhTi8dX2cR2aBuWPZkiQxyKaZTvHrI=";
    "11.6" = "sha256-AsLNmAplfuQbXg9zt09tXAuFJ524EtTYsQuUlV1tPkE=";
    # The tag 11.7 of cuda-samples does not exist
    "11.8" = "sha256-7+1P8+wqTKUGbCUBXGMDO9PkxYr2+PLDx9W2hXtXbuc=";
    "12.0" = "sha256-Lj2kbdVFrJo5xPYPMiE4BS7Z8gpU5JLKXVJhZABUe/g=";
    "12.1" = "sha256-xE0luOMq46zVsIEWwK4xjLs7NorcTIi9gbfZPVjIlqo=";
    "12.2" = "sha256-pOy0qfDjA/Nr0T9PNKKefK/63gQnJV2MQsN2g3S2yng=";
    "12.3" = "sha256-fjVp0G6uRCWxsfe+gOwWTN+esZfk0O5uxS623u0REAk=";
    "12.4" = "sha256-D+kP1OEJ4zR/9wKL+jjAv3TRv1IdX39mhZ1MvobX6F0=";
    "12.4.1" = "sha256-vJmqAIrOiYTXuPLcqBXDdayQvdLpJGJYK60KEDT1sgo=";
  };

  # Provide a fake for OfBorg when evaluating with allowBroken=true.
  # Start with the most specific version, and relax as needed.
  hash =
    cudaVersionToHash.${cudaMajorMinorPatchVersion} or cudaVersionToHash.${cudaMajorMinorVersion}
      or misc.fakeHash;
in
backendStdenv.mkDerivation (finalAttrs: {
  # Don't force serialization to string for structured attributes, like outputToPatterns
  # and brokenConditions.
  # Avoids "set cannot be coerced to string" errors.
  __structuredAttrs = true;

  # Keep better track of dependencies.
  strictDeps = true;

  name = "cuda${cudaMajorMinorVersion}-${finalAttrs.pname}";
  pname = "cuda-samples";
  version = cudaMajorMinorPatchVersion;

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = finalAttrs.pname;
    rev = "v${finalAttrs.version}";
    inherit hash;
  };

  # brokenConditions :: AttrSet Bool
  # Sets `meta.broken = true` if any of the conditions are true.
  # Example: Broken on a specific version of CUDA or when a dependency has a specific version.
  brokenConditions = {
    "CUDA version is unsupported" = hash == misc.fakeHash;
  };

  # badPlatformsConditions :: AttrSet Bool
  # Sets `meta.badPlatforms = meta.platforms` if any of the conditions are true.
  # Example: Broken on a specific architecture when some condition is met (like targeting Jetson).
  badPlatformsConditions = {
    # Samples are built around the CUDA Toolkit, which is not available for
    # aarch64. Check for both CUDA version and platform.
    "Platform is unsupported" = !hostPlatform.isx86_64;
  };

  nativeBuildInputs =
    [
      autoAddDriverRunpath
      pkg-config
    ]
    # CMake has to run as a native, build-time dependency for libNVVM samples.
    # However, it's not the primary build tool -- that's still make.
    # As such, we disable CMake's build system.
    ++ lists.optionals (strings.versionAtLeast finalAttrs.version "12.2") [ cmake ];

  dontUseCmakeConfigure = true;

  buildInputs = [
    cudatoolkit-legacy-runfile
    freeimage
    glfw3
  ];

  # See https://github.com/NVIDIA/cuda-samples/issues/75.
  patches = lib.optionals (finalAttrs.version == "11.3") [
    (fetchpatch {
      url = "https://github.com/NVIDIA/cuda-samples/commit/5c3ec60faeb7a3c4ad9372c99114d7bb922fda8d.patch";
      hash = "sha256-0XxdmNK9MPpHwv8+qECJTvXGlFxc+fIbta4ynYprfpU=";
    })
  ];

  enableParallelBuilding = true;

  preConfigure = ''
    export CUDA_PATH=${cudatoolkit-legacy-runfile}
    export SMS=${strings.replaceStrings [ ";" ] [ " " ] cudaFlags.cmakeCudaArchitecturesString}
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 -t $out/bin bin/${stdenv.hostPlatform.parsed.cpu.name}/${stdenv.hostPlatform.parsed.kernel.name}/release/*

    runHook postInstall
  '';

  meta = {
    description = "Samples for CUDA Developers which demonstrates features in CUDA Toolkit";
    # CUDA itself is proprietary, but these sample apps are not.
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ obsidian-systems-maintenance ] ++ lib.teams.cuda.members;
    broken = lists.any trivial.id (attrsets.attrValues finalAttrs.brokenConditions);
    platforms = [ "x86_64-linux" ];
    badPlatforms =
      let
        isBadPlatform = lists.any trivial.id (attrsets.attrValues finalAttrs.badPlatformsConditions);
      in
      lists.optionals isBadPlatform finalAttrs.meta.platforms;
  };
})

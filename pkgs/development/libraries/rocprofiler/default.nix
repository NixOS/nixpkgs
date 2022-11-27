{ lib
, stdenv
, fetchFromGitHub
, writeScript
, cmake
, roctracer
, hsa-amd-aqlprofile
, hip
, numactl
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rocprofiler";
  rocmVersion = "5.3.3";
  version = finalAttrs.rocmVersion;

  src = fetchFromGitHub {
    owner = "ROCm-Developer-Tools";
    repo = "rocprofiler";
    rev = "rocm-${finalAttrs.rocmVersion}";
    hash = "sha256-e7d78nQYTlMAq6nTcGRhNUGu3Ms1qvv17ET5RTgqKyU=";
  };

  nativeBuildInputs = [
    cmake
    hip
  ];

  buildInputs = [
    hsa-amd-aqlprofile
    numactl
  ];

  cmakeFlags = [
    "-DCMAKE_C_COMPILER=hipcc"
    "-DCMAKE_CXX_COMPILER=hipcc"
    "-DPROF_API_HEADER_PATH=${roctracer.src}/inc/ext"
  ];

  postPatch = ''
    patchShebangs test/run.sh
    patchShebangs bin/*.sh
  '';

  postInstall = ''
    patchelf --set-rpath ${lib.makeLibraryPath (finalAttrs.nativeBuildInputs ++ finalAttrs.buildInputs)}:$out/lib $out/lib/rocprofiler/librocprof-tool.so*
  '';

  passthru.updateScript = writeScript "update.sh" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p curl jq common-updater-scripts
    rocmVersion="$(curl -sL "https://api.github.com/repos/ROCm-Developer-Tools/rocprofiler/releases?per_page=1" | jq '.[0].tag_name | split("-") | .[1]' --raw-output)"
    update-source-version rocprofiler "$rocmVersion" --ignore-same-hash --version-key=rocmVersion
  '';

  meta = with lib; {
    description = "Profiling with perf-counters and derived metrics";
    homepage = "https://github.com/ROCm-Developer-Tools/rocprofiler";
    license = with licenses; [ mit ]; # mitx11
    maintainers = teams.rocm.members;
    broken = finalAttrs.rocmVersion != hip.version;
  };
})

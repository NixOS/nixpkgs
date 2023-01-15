{ lib
, stdenv
, fetchFromGitHub
, rocmUpdateScript
, cmake
, hip
, git
, rocdbgapi
, rocm-runtime
, elfutils
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rocr-debug-agent";
  version = "5.4.1";

  src = fetchFromGitHub {
    owner = "ROCm-Developer-Tools";
    repo = "rocr_debug_agent";
    rev = "rocm-${finalAttrs.version}";
    hash = "sha256-5l6svWSWCxVoyr1zJabxbt5rXQMtdZtHrf9gS2PcRKc=";
  };

  nativeBuildInputs = [
    cmake
    hip
    git
  ];

  buildInputs = [
    rocdbgapi
    rocm-runtime
    elfutils
  ];

  cmakeFlags = [
    "-DCMAKE_MODULE_PATH=${hip}/lib/cmake/hip"
    "-DHIP_ROOT_DIR=${hip}"
    "-DHIP_PATH=${hip}"
  ];

  # Weird install target
  postInstall = ''
    rm -rf $out/src
  '';

  passthru.updateScript = rocmUpdateScript {
    name = finalAttrs.pname;
    owner = finalAttrs.src.owner;
    repo = finalAttrs.src.repo;
  };

  meta = with lib; {
    description = "Library that provides some debugging functionality for ROCr";
    homepage = "https://github.com/ROCm-Developer-Tools/rocr_debug_agent";
    license = with licenses; [ ncsa ];
    maintainers = teams.rocm.members;
    platforms = platforms.linux;
    broken = versions.minor finalAttrs.version != versions.minor hip.version;
  };
})

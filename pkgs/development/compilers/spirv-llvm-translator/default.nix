{ lib, stdenv
, fetchFromGitHub
, fetchpatch
, cmake
, pkg-config
, lit
, llvm
, spirv-headers
, spirv-tools
}:

let
  llvmMajor = lib.versions.major llvm.version;
  isROCm = lib.hasPrefix "rocm" llvm.pname;

  # ROCm will always be at the latest version
  branch =
    if llvmMajor == "16" then rec {
      version = "16.0.0";
      rev = "v${version}";
      hash = "sha256-EUabcYqSjXshbPmcs1DRLvCSL1nd9rEdpqELBrItCW8=";
    } else if llvmMajor == "15" || isROCm then rec {
      version = "15.0.0";
      rev = "v${version}";
      hash = "sha256-OsDohXRxovtEXaWiRGp8gJ0dXmoALyO+ZimeSO8aPVI=";
    } else if llvmMajor == "14" then rec{
      version = "14.0.0";
      rev = "v${version}";
      hash = "sha256-BhNAApgZ/w/92XjpoDY6ZEIhSTwgJ4D3/EfNvPmNM2o=";
    } else if llvmMajor == "11" then {
      version = "unstable-2022-05-04";
      rev = "4ef524240833abfeee1c5b9fff6b1bd53f4806b3"; # 267 commits ahead of v11.0.0
      hash = "sha256-NoIoa20+2sH41rEnr8lsMhtfesrtdPINiXtUnxYVm8s=";
    } else throw "Incompatible LLVM version.";
in
stdenv.mkDerivation {
  pname = "SPIRV-LLVM-Translator";
  inherit (branch) version;

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "SPIRV-LLVM-Translator";
    inherit (branch) rev hash;
  };

  patches = lib.optionals (llvmMajor == "16")[
    # Fixes builds that link against external LLVM dynamic library
    (fetchpatch {
      url = "https://github.com/KhronosGroup/SPIRV-LLVM-Translator/commit/f3b9b604d7eda18d0d1029d94a6eebd33aa3a3fe.patch";
      hash = "sha256-opDjyZcy7O4wcSfm/A51NCIiDyIvbcmbv9ns1njdJbc=";
    })
  ];

  nativeBuildInputs = [ pkg-config cmake spirv-tools ]
    ++ (if isROCm then [ llvm ] else [ llvm.dev ]);

  buildInputs = [ spirv-headers ]
    ++ lib.optionals (!isROCm) [ llvm ];

  nativeCheckInputs = [ lit ];

  cmakeFlags = [
    "-DLLVM_INCLUDE_TESTS=ON"
    "-DLLVM_DIR=${(if isROCm then llvm else llvm.dev)}"
    "-DBUILD_SHARED_LIBS=YES"
    "-DLLVM_SPIRV_BUILD_EXTERNAL=YES"
    # RPATH of binary /nix/store/.../bin/llvm-spirv contains a forbidden reference to /build/
    "-DCMAKE_SKIP_BUILD_RPATH=ON"
  ] ++ lib.optionals (llvmMajor != "11") [ "-DLLVM_EXTERNAL_SPIRV_HEADERS_SOURCE_DIR=${spirv-headers.src}" ];

  # FIXME: CMake tries to run "/llvm-lit" which of course doesn't exist
  doCheck = false;

  makeFlags = [ "all" "llvm-spirv" ];

  postInstall = ''
    install -D tools/llvm-spirv/llvm-spirv $out/bin/llvm-spirv
  '' + lib.optionalString stdenv.isDarwin ''
    install_name_tool $out/bin/llvm-spirv \
      -change @rpath/libLLVMSPIRVLib.dylib $out/lib/libLLVMSPIRVLib.dylib
  '';

  meta = with lib; {
    homepage    = "https://github.com/KhronosGroup/SPIRV-LLVM-Translator";
    description = "A tool and a library for bi-directional translation between SPIR-V and LLVM IR";
    license     = licenses.ncsa;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ gloaming ];
  };
}

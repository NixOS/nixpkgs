{ lib, stdenv
, fetchFromGitHub
, fetchpatch
, cmake
, pkg-config
, lit
, llvm
, spirv-headers
, spirv-tools
, disable-warnings-if-gcc13
}:

let
  llvmMajor = lib.versions.major llvm.version;
  isROCm = lib.hasPrefix "rocm" llvm.pname;

  # ROCm, if actively updated will always be at the latest version
  branch =
    if llvmMajor == "17" || isROCm then rec {
      version = "17.0.0";
      rev = "v${version}";
      hash = "sha256-Rzm5Py9IPFtS9G7kME+uSwZ/0gPGW6MlL35ZWk4LfHM=";
    } else if llvmMajor == "16" then rec {
      version = "16.0.0";
      rev = "v${version}";
      hash = "sha256-EUabcYqSjXshbPmcs1DRLvCSL1nd9rEdpqELBrItCW8=";
    } else if llvmMajor == "15" then rec {
      version = "15.0.0";
      rev = "v${version}";
      hash = "sha256-OsDohXRxovtEXaWiRGp8gJ0dXmoALyO+ZimeSO8aPVI=";
    } else if llvmMajor == "14" then rec{
      version = "14.0.0+unstable-2023-06-22";
      rev = "23f398bf369093b1fd67459db8071ffcc6b92658";
      hash = "sha256-o7cVj5/ZMER2CvfxL4pRb2qCIxC/HFUPiitf2fKtCyk=";
    } else if llvmMajor == "11" then {
      version = "11.0.0+unstable-2022-05-04";
      rev = "4ef524240833abfeee1c5b9fff6b1bd53f4806b3"; # 267 commits ahead of v11.0.0
      hash = "sha256-NoIoa20+2sH41rEnr8lsMhtfesrtdPINiXtUnxYVm8s=";
    } else throw "Incompatible LLVM version.";
in
disable-warnings-if-gcc13 (stdenv.mkDerivation {
  pname = "SPIRV-LLVM-Translator";
  inherit (branch) version;

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "SPIRV-LLVM-Translator";
    inherit (branch) rev hash;
  };

  patches = [
    # Fixes build after spirv-headers breaking change
    (fetchpatch {
      url = "https://github.com/KhronosGroup/SPIRV-LLVM-Translator/commit/0166a0fb86dc6c0e8903436bbc3a89bc3273ebc0.patch";
      excludes = ["spirv-headers-tag.conf"];
      hash = "sha256-17JJG8eCFVphElY5fVT/79hj0bByWxo8mVp1ZNjQk/M=";
    })
  ] ++ lib.optionals (llvmMajor == "16") [
    # Fixes builds that link against external LLVM dynamic library
    (fetchpatch {
      url = "https://github.com/KhronosGroup/SPIRV-LLVM-Translator/commit/f3b9b604d7eda18d0d1029d94a6eebd33aa3a3fe.patch";
      hash = "sha256-opDjyZcy7O4wcSfm/A51NCIiDyIvbcmbv9ns1njdJbc=";
    })
  ] ++ lib.optionals (llvmMajor == "14") [
    (fetchpatch {
      # tries to install llvm-spirv into llvm nix store path
      url = "https://github.com/KhronosGroup/SPIRV-LLVM-Translator/commit/cce9a2f130070d799000cac42fe24789d2b777ab.patch";
      revert = true;
      hash = "sha256-GbFacttZRDCgA0jkUoFA4/B3EDn3etweKvM09OwICJ8=";
    })
  ];

  nativeBuildInputs = [ pkg-config cmake ]
    ++ (if isROCm then [ llvm ] else [ llvm.dev ]);

  buildInputs = [ spirv-headers spirv-tools ]
    ++ lib.optionals (!isROCm) [ llvm ];

  nativeCheckInputs = [ lit ];

  cmakeFlags = [
    "-DLLVM_INCLUDE_TESTS=ON"
    "-DLLVM_DIR=${(if isROCm then llvm else llvm.dev)}"
    "-DBUILD_SHARED_LIBS=YES"
    "-DLLVM_SPIRV_BUILD_EXTERNAL=YES"
    # RPATH of binary /nix/store/.../bin/llvm-spirv contains a forbidden reference to /build/
    "-DCMAKE_SKIP_BUILD_RPATH=ON"
  ] ++ lib.optional (llvmMajor != "11") "-DLLVM_EXTERNAL_SPIRV_HEADERS_SOURCE_DIR=${spirv-headers.src}";

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
})

{ stdenv, fetchFromGitHub, cmake, elfutils, rocm-thunk }:

stdenv.mkDerivation rec {
  pname = "rocm-runtime";
  version = "3.5.0";

  src = fetchFromGitHub {
    owner = "RadeonOpenCompute";
    repo = "ROCR-Runtime";
    rev = "rocm-${version}";
    sha256 = "028x1f0if6lw41cpfpysp82ikp6c3fdxxd2a6ixs0vpm4424svb1";
  };

  sourceRoot = "source/src";

  buildInputs = [ cmake elfutils ];

  cmakeFlags = [ "-DCMAKE_PREFIX_PATH=${rocm-thunk}" ];

  # Use the ROCR_EXT_DIR environment variable to try to find
  # binary-only extension libraries. This environment variable is set
  # by the `rocr-ext` derivation. If that derivation is not in scope,
  # then the extension libraries are not loaded. Without this edit, we
  # would have to rely on LD_LIBRARY_PATH to let the HSA runtime
  # discover the shared libraries.
  patchPhase = ''
    sed 's/\(k\(Image\|Finalizer\)Lib\[os_index(os::current_os)\]\)/os::GetEnvVar("ROCR_EXT_DIR") + "\/" + \1/g' -i core/runtime/runtime.cpp
  '';

  fixupPhase = ''
    rm -r $out/lib $out/include
    mv $out/hsa/lib $out/hsa/include $out
  '';

  meta = with stdenv.lib; {
    description = "Platform runtime for ROCm";
    homepage = "https://github.com/RadeonOpenCompute/ROCR-Runtime";
    license = with licenses; [ ncsa ];
    maintainers = with maintainers; [ danieldk ];
  };
}

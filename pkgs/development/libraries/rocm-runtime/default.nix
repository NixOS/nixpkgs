{ stdenv
, fetchFromGitHub
, addOpenGLRunpath
, cmake
, elfutils
, rocm-thunk }:

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

  # Use the ROCR_EXT_DIR environment variable and/or OpenGL driver
  # link path to try to find binary-only ROCm runtime extension
  # libraries.  Without this change, we would have to rely on
  # LD_LIBRARY_PATH to let the HSA runtime discover the shared
  # libraries.
  patchPhase = ''
    substitute '${./rocr-ext-dir.diff}' ./rocr-ext-dir.diff \
      --subst-var-by rocrExtDir "${addOpenGLRunpath.driverLink}/lib/rocm-runtime-ext"
    patch -p2 < ./rocr-ext-dir.diff
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

{
  backendStdenv,
  buildRedist,
  cuda_nvrtc,
  cudaMajorMinorVersion,
  lib,
  manifests,
}:
let
  cudaCublasVersion = manifests.cuda.libcublas.version;
  standaloneVersion = manifests.cublas.libcublas.version;

  # Package sets may select a standalone cuBLAS release, which must be a newer patch release of the cuBLAS shipped with
  # CUDA. Use it when it has a build for the host.
  isStandalone =
    manifests ? cublas
    &&
      lib.assertMsg
        (
          lib.versions.majorMinor standaloneVersion == lib.versions.majorMinor cudaCublasVersion
          && lib.versionOlder cudaCublasVersion standaloneVersion
        )
        "libcublas: standalone cuBLAS ${standaloneVersion} is not a newer patch release of CUDA's cuBLAS ${cudaCublasVersion}; drop or update the cublas pin"
    && manifests.cublas.libcublas ? ${backendStdenv.hostRedistSystem};
in
buildRedist (finalAttrs: {
  redistName = if isStandalone then "cublas" else "cuda";
  pname = "libcublas";

  # libcublasLt dlopens NVRTC to compile kernels at runtime; absent before 12.8.
  appendRunpaths = lib.optionals (lib.versionAtLeast finalAttrs.version "12.8") [
    "${lib.getLib cuda_nvrtc}/lib" # libnvrtc.so.%s
  ];

  outputs = [
    "out"
    "dev"
    "include"
    "lib"
    "static"
    "stubs"
  ];

  # Standalone archives lack the stubs and pkg-config file shipped with CUDA's cuBLAS, so generate them. Like NVIDIA's,
  # the stubs define the libraries' versioned functions, each of which prints a warning.
  ${if isStandalone then "postUnpack" else null} = ''
    mkdir "$sourceRoot/lib/stubs"
    for base in cublas cublasLt; do
      real="$sourceRoot/lib/lib$base.so"
      stub="$sourceRoot/lib/stubs/lib$base.so"
      nixLog "generating $stub"
      $NM --dynamic --defined-only --format=posix "$real" | awk -v base="$base" '
        BEGIN { print "#include <stdio.h>" > base ".c" }
        $2 == "T" {
          split($1, sym, "@@")
          print "int " sym[1] "(void) { return puts(\"You are running using the stub version of " base "\"); }" > base ".c"
          syms[sym[2]] = syms[sym[2]] " " sym[1] ";"
        }
        END { for (ver in syms) print ver " { global:" syms[ver] " local: *; };" > base ".map" }
      '
      $CC -shared -fPIC -o "$stub" "$base.c" -Wl,--version-script="$base.map" \
        -Wl,-soname,"$($READELF --dynamic "$real" | sed -n 's/.*(SONAME).*\[\(.*\)\]$/\1/p')"
      diff <($NM --dynamic --defined-only "$real" | cut -d' ' -f2-) <($NM --dynamic --defined-only "$stub" | cut -d' ' -f2-)
    done

    mkdir "$sourceRoot/pkg-config"
    cat >"$sourceRoot/pkg-config/cublas-${cudaMajorMinorVersion}.pc" <<'EOF'
    cudaroot=/usr/local/cuda-${cudaMajorMinorVersion}
    libdir=''${cudaroot}/lib
    includedir=''${cudaroot}/include

    Name: cublas
    Description: CUDA Basic Linear Algebra Subprograms
    Version: ${cudaMajorMinorVersion}
    Libs: -L''${libdir} -lcublas
    Cflags: -I''${includedir}
    EOF
  '';

  meta = {
    description = "CUDA Basic Linear Algebra Subroutine library";
    longDescription = ''
      The cuBLAS library is an implementation of BLAS (Basic Linear Algebra Subprograms) on top of the NVIDIA CUDA runtime.
    '';
    homepage = "https://developer.nvidia.com/cublas";
    license = lib.licenses.nvidiaCudaRedist;
  };
})

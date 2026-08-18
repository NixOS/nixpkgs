{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  py-cpuinfo,
  h5py,
  pkgconfig,
  c-blosc,
  c-blosc2,
  bzip2,
  charls,
  lz4,
  zfp,
  zlib,
  zstd,
  stdenv,
  sse2Support ? stdenv.hostPlatform.avx2Support,
  ssse3Support ? stdenv.hostPlatform.ssse3Support,
  avx2Support ? stdenv.hostPlatform.avx2Support,
  avx512Support ? stdenv.hostPlatform.avx512Support,
}:

let
  c-blosc' = c-blosc.override { snappySupport = true; };
  # H5Z-ZFP needs an 8-bit bitstream word so the compressed HDF5 data is byte-portable
  zfp' = zfp.override { bitStreamWordSize = 8; };
in
buildPythonPackage (finalAttrs: {
  pname = "hdf5plugin";
  version = "7.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "silx-kit";
    repo = "hdf5plugin";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wi5EITlRI8tgAXUV5u/CA3eiWjNAVs5ynT+PUsqcqVA=";
  };

  build-system = [
    setuptools
    py-cpuinfo
    pkgconfig # only needed if HDF5PLUGIN_SYSTEM_LIBRARIES is used
  ];

  dependencies = [ h5py ];

  buildInputs = [
    c-blosc'
    c-blosc2
    bzip2
    charls
    lz4
    zfp'
    zlib
    zstd
  ];

  # devendor
  postPatch = ''
    rm -rf lib/c-blosc
    rm -rf lib/c-blosc2
    rm -rf lib/bzip2
    rm -rf lib/charls
    rm -rf lib/zfp
    rm -rf lib/zstd
  '';

  # opt-in to use use system libs instead
  env.HDF5PLUGIN_SYSTEM_LIBRARIES = lib.concatStringsSep "," [
    "blosc"
    "blosc2"
    "bzip2"
    "charls"
    "lz4"
    # "sperr" # not packaged?
    "zfp"
    "zlib"
    "zstd"
  ];

  # These feature defaults can enable CPU-specific code during the build:
  # most are detected from the build host CPU, while BMI2 defaults to enabled
  # on Linux/Darwin. Pin them to keep the output generic and machine-independent.
  # https://github.com/silx-kit/hdf5plugin/blob/v6.0.0/doc/install.rst#available-options
  env.HDF5PLUGIN_NATIVE = "False";
  env.HDF5PLUGIN_SSE2 = if sse2Support then "True" else "False";
  env.HDF5PLUGIN_SSSE3 = if ssse3Support then "True" else "False";
  env.HDF5PLUGIN_AVX2 = if avx2Support then "True" else "False";
  env.HDF5PLUGIN_AVX512 = if avx512Support then "True" else "False";

  checkPhase = ''
    python test/test.py
  '';

  pythonImportsCheck = [ "hdf5plugin" ];

  preBuild = ''
    mkdir src/hdf5plugin/plugins

    mkdir -p pkg-config
    export PKG_CONFIG_PATH="$PWD/pkg-config''${PKG_CONFIG_PATH:+:$PKG_CONFIG_PATH}"

    # zfp ships only a CMake config; synthesise the pkg-config module hdf5plugin probes for
    cat >pkg-config/zfp.pc <<EOF
    includedir=${lib.getDev zfp'}/include
    Name: zfp
    Version: ${zfp'.version}
    Description: zfp
    Libs: -L${lib.getLib zfp'}/lib -lzfp
    Cflags: -I${lib.getDev zfp'}/include
    EOF
  '';

  meta = {
    description = "Additional compression filters for h5py";
    longDescription = ''
      hdf5plugin provides HDF5 compression filters and makes them usable from h5py.
      Supported encodings: Blosc, Blosc2, BitShuffle, BZip2, FciDecomp, LZ4, SZ, SZ3, Zfp, ZStd
    '';
    homepage = "http://www.silx.org/doc/hdf5plugin/latest/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pbsds ];
  };
})

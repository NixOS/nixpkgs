{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  py-cpuinfo,
  h5py,
  pkgconfig,
  c-blosc2,
  charls,
  lz4,
  zlib,
  zstd,
}:

buildPythonPackage rec {
  pname = "hdf5plugin";
  version = "6.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "silx-kit";
    repo = "hdf5plugin";
    tag = "v${version}";
    hash = "sha256-LW6rY+zLta4hENBbTll+1amf9TYJiuAumwzgpk1LZ3M=";
  };

  build-system = [
    setuptools
    py-cpuinfo
    pkgconfig # only needed if HDF5PLUGIN_SYSTEM_LIBRARIES is used
  ];

  dependencies = [ h5py ];

  buildInputs = [
    #c-blosc
    c-blosc2
    # bzip2_1_1
    charls
    lz4
    # snappy
    # zfp
    zlib
    zstd
  ];

  # opt-in to use use system libs instead
  env.HDF5PLUGIN_SYSTEM_LIBRARIES = lib.concatStringsSep "," [
    #"blosc" # AssertionError: 4000 not less than 4000
    "blosc2"
    # "bz2" # only works with bzip2_1_1
    "charls"
    "lz4"
    # "snappy" # snappy tests fail
    # "sperr" # not packaged?
    # "zfp" #  pkgconfig: (lib)zfp not found
    "zlib"
    "zstd"
  ];

  # These feature defaults can enable CPU-specific code during the build:
  # most are detected from the build host CPU, while BMI2 defaults to enabled
  # on Linux/Darwin. Pin them to keep the output generic and machine-independent.
  # https://github.com/silx-kit/hdf5plugin/blob/v6.0.0/doc/install.rst#available-options
  env.HDF5PLUGIN_NATIVE = "False";
  env.HDF5PLUGIN_SSE2 = "False";
  env.HDF5PLUGIN_SSSE3 = "False";
  env.HDF5PLUGIN_AVX2 = "False";
  env.HDF5PLUGIN_AVX512 = "False";

  checkPhase = ''
    python test/test.py
  '';

  pythonImportsCheck = [ "hdf5plugin" ];

  preBuild = ''
    mkdir src/hdf5plugin/plugins
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
}

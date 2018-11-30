{ stdenv, lib, config, fetchFromGitHub
, cmake
, glog, google-gflags, gtest
, protobuf, snappy
, python, future, six, python-protobuf, numpy, pydot
, eigen
, doxygen
, useCuda ? (config.cudaSupport or false), cudatoolkit ? null
, useCudnn ? (config.cudnnSupport or false), cudnn ? null
, useOpenmp ? false, openmp ? null
, useOpencv3 ? true, opencv3 ? null
, useLeveldb ? false, leveldb ? null
, useLmdb ? true, lmdb ? null
, useRocksdb ? false, rocksdb ? null
, useZeromq ? false, zeromq ? null
, useMpi ? false, mpi ? null
# TODO: distributed computations
#, useGloo ? false
#, useNccl ? false
#, useNnpack ? false
}:

assert useCuda -> cudatoolkit != null;
assert useCudnn -> (useCuda && cudnn != null);
assert useOpencv3 -> opencv3 != null;
assert useLeveldb -> leveldb != null;
assert useLmdb -> lmdb != null;
assert useRocksdb -> rocksdb != null;
assert useZeromq -> zeromq != null;
assert useMpi -> mpi != null;

let
  # Third party modules that caffe2 holds as git submodules.
  # Download them and create symlinks from caffe2/third_party.
  installExtraSrc = extra: ''
    rmdir "third_party/${extra.dst}"
    ln -s "${extra.src}" "third_party/${extra.dst}"
  '';

  cub = {
    src = fetchFromGitHub rec {
      owner  = "NVlabs";
      repo   = "cub";
      rev    = "v1.7.4";
      sha256 = "0ksd5n1lxqhm5l5cd2lps4cszhjkf6gmzahaycs7nxb06qci8c66";
    };
    dst = "cub";
  };

  pybind11 = {
    src = fetchFromGitHub {
      owner  = "pybind";
      repo   = "pybind11";
      rev    = "86e2ad4f77442c3350f9a2476650da6bee253c52";
      sha256 = "05gi58dirvc8fgm0avpydvidzsbh2zrzgfaq671ym09f6dz0bcgz";
    };
    dst = "pybind11";
  };

  ccVersion = (builtins.parseDrvName stdenv.cc.name).version;
in

stdenv.mkDerivation rec {
  name = "caffe2-${version}";
  version = "0.8.1";
  src = fetchFromGitHub {
    owner = "caffe2";
    repo = "caffe2";
    rev = "v${version}";
    sha256 = "18y7zjc69j6n5642l9caddl641b0djf3pjn4wacdsc1wk1jiyqk8";
  };

  nativeBuildInputs = [ cmake doxygen gtest ];
  outputs = [ "bin" "out" ];
  propagatedBuildOutputs = [ ]; # otherwise propagates out -> bin cycle

  buildInputs = [ glog google-gflags protobuf snappy eigen ]
    ++ lib.optional useCuda cudatoolkit
    ++ lib.optional useCudnn cudnn
    ++ lib.optional useOpenmp openmp
    ++ lib.optional useOpencv3 opencv3
    ++ lib.optional useLeveldb leveldb
    ++ lib.optional useLmdb lmdb
    ++ lib.optional useRocksdb rocksdb
    ++ lib.optional useZeromq zeromq
  ;
  propagatedBuildInputs = [ numpy future six python-protobuf pydot ];

  patches = lib.optional (stdenv.cc.isGNU && lib.versionAtLeast ccVersion "7.0.0") [
    ./fix_compilation_on_gcc7.patch
  ] ++ lib.optional stdenv.cc.isClang [ ./update_clang_cvtsh_bugfix.patch ];

  cmakeFlags = [ ''-DBUILD_TEST=OFF''
                 ''-DBUILD_PYTHON=ON''
                 ''-DUSE_CUDA=${if useCuda then ''ON''else ''OFF''}''
                 ''-DUSE_OPENMP=${if useOpenmp then ''ON''else ''OFF''}''
                 ''-DUSE_OPENCV=${if useOpencv3 then ''ON''else ''OFF''}''
                 ''-DUSE_MPI=${if useMpi then ''ON''else ''OFF''}''
                 ''-DUSE_LEVELDB=${if useLeveldb then ''ON''else ''OFF''}''
                 ''-DUSE_LMDB=${if useLmdb then ''ON''else ''OFF''}''
                 ''-DUSE_ROCKSDB=${if useRocksdb then ''ON''else ''OFF''}''
                 ''-DUSE_ZMQ=${if useZeromq  then ''ON''else ''OFF''}''
                 ''-DUSE_GLOO=OFF''
                 ''-DUSE_NNPACK=OFF''
                 ''-DUSE_NCCL=OFF''
                 ''-DUSE_REDIS=OFF''
                 ''-DUSE_FFMPEG=OFF''
               ]
               ++ lib.optional useCuda [
                 ''-DCUDA_TOOLKIT_ROOT_DIR=${cudatoolkit}''
                 ''-DCUDA_FAST_MATH=ON''
                 ''-DCUDA_HOST_COMPILER=${cudatoolkit.cc}/bin/gcc''
               ];

  preConfigure = ''
    ${installExtraSrc cub}
    ${installExtraSrc pybind11}
    # XXX hack
    export NIX_CFLAGS_COMPILE="-I ${eigen}/include/eigen3/ $NIX_CFLAGS_COMPILE"
  '';

  postInstall = ''
    moveToOutput "bin" "$bin"
    mkdir -p $out/lib/${python.libPrefix}
    ln -s $out/ $out/${python.sitePackages}
  '';

  doCheck = false;
  enableParallelBuilding = true;

  meta = {
    homepage = https://caffe2.ai/;
    description = "A new lightweight, modular, and scalable deep learning framework";
    longDescription = ''
      Caffe2 aims to provide an easy and straightforward way for you to experiment
      with deep learning and leverage community contributions of new models and
      algorithms. You can bring your creations to scale using the power of GPUs in the
      cloud or to the masses on mobile with Caffe2's cross-platform libraries.
    '';
    platforms = with stdenv.lib.platforms; linux;
    license = stdenv.lib.licenses.asl20;
    maintainers = with stdenv.lib.maintainers; [ yuriaisaka ];
  };
}

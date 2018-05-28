{ stdenv
, lib
, fetchPypi
, gcc
, writeScriptBin
, buildPythonPackage
, isPyPy
, pythonOlder
, isPy3k
, nose
, numpy
, pydot_ng
, scipy
, six
, libgpuarray
, cudaSupport ? false, cudatoolkit
, cudnnSupport ? false, cudnn
, nvidia_x11
}:

assert cudnnSupport -> cudaSupport;

assert cudaSupport -> nvidia_x11 != null
                   && cudatoolkit != null
                   && cudnn != null;

let
  extraFlags =
    lib.optionals cudaSupport [ "-I ${cudatoolkit}/include" "-L ${cudatoolkit}/lib" ]
    ++ lib.optionals cudnnSupport [ "-I ${cudnn}/include" "-L ${cudnn}/lib" ]
    ++ lib.optionals cudaSupport [ "-I ${libgpuarray}/include" "-L ${libgpuarray}/lib" ];

  gcc_ = writeScriptBin "g++" ''
    #!${stdenv.shell}
    export NIX_CC_WRAPPER_${stdenv.cc.infixSalt}_TARGET_HOST=1
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE ${toString extraFlags}"
    exec ${gcc}/bin/g++ "$@"
  '';

  libgpuarray_ = libgpuarray.override { inherit cudaSupport; };

in buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "Theano";
  version = "1.0.2";

  disabled = isPyPy || pythonOlder "2.6" || (isPy3k && pythonOlder "3.3");

  src = fetchPypi {
    inherit pname version;
    sha256 = "6768e003d328a17011e6fca9126fbb8a6ffd3bb13cb21c450f3e724cca29abde";
  };

  postPatch = ''
    sed -i 's,g++,${gcc_}/bin/g++,g' theano/configdefaults.py
  '' + lib.optionalString cudnnSupport ''
    sed -i \
      -e "s,ctypes.util.find_library('cudnn'),'${cudnn}/lib/libcudnn.so',g" \
      -e "s/= _dnn_check_compile()/= (True, None)/g" \
      theano/gpuarray/dnn.py
  '';

  preCheck = ''
    mkdir -p check-phase
    export HOME=$(pwd)/check-phase
  '';
  doCheck = false;
  # takes far too long, also throws "TypeError: sort() missing 1 required positional argument: 'a'"
  # when run from the installer, and testing with Python 3.5 hits github.com/Theano/Theano/issues/4276,
  # the fix for which hasn't been merged yet.

  # keep Nose around since running the tests by hand is possible from Python or bash
  checkInputs = [ nose ];
  propagatedBuildInputs = [ numpy numpy.blas scipy six libgpuarray_ ];

  meta = with stdenv.lib; {
    homepage = http://deeplearning.net/software/theano/;
    description = "A Python library for large-scale array computation";
    license = licenses.bsd3;
    maintainers = with maintainers; [ maintainers.bcdarwin ];
  };
}

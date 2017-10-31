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
}:

assert cudnnSupport -> cudaSupport;

let
  extraFlags =
    lib.optionals cudaSupport [ "-I ${cudatoolkit}/include" "-L ${cudatoolkit}/lib" ]
    ++ lib.optionals cudnnSupport [ "-I ${cudnn}/include" "-L ${cudnn}/lib" ];

  gcc_ = writeScriptBin "g++" ''
    #!${stdenv.shell}
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE ${toString extraFlags}"
    exec ${gcc}/bin/g++ "$@"
  '';

  libgpuarray_ = libgpuarray.override { inherit cudaSupport; };

in buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "Theano";
  version = "0.9.0";

  disabled = isPyPy || pythonOlder "2.6" || (isPy3k && pythonOlder "3.3");

  src = fetchPypi {
    inherit pname version;
    sha256 = "05xwg00da8smkvkh6ywbywqzj8dw7x840jr74wqhdy9icmqncpbl";
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

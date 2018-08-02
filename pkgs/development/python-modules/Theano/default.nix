{ stdenv
, runCommandCC
, lib
, fetchPypi
, gcc
, buildPythonPackage
, isPyPy
, pythonOlder
, isPy3k
, nose
, numpy
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
  wrapped = command: buildTop: buildInputs:
    runCommandCC "${command}-wrapped" { inherit buildInputs; } ''
      type -P '${command}' || { echo '${command}: not found'; exit 1; }
      cat > "$out" <<EOF
      #!$(type -P bash)
      $(declare -xp | sed -e '/^[^=]\+="\('"''${NIX_STORE//\//\\/}"'\|[^\/]\)/!d')
      declare -x NIX_BUILD_TOP="${buildTop}"
      $(type -P '${command}') "\$@"
      EOF
      chmod +x "$out"
    '';

  # Theano spews warnings and disabled flags if the compiler isn't named g++
  cxx_compiler = wrapped "g++" "\\$HOME/.theano"
    (    stdenv.lib.optional cudaSupport libgpuarray_
      ++ stdenv.lib.optional cudnnSupport cudnn );

  libgpuarray_ = libgpuarray.override { inherit cudaSupport cudatoolkit; };

in buildPythonPackage rec {
  pname = "Theano";
  version = "1.0.2";

  disabled = isPyPy || pythonOlder "2.6" || (isPy3k && pythonOlder "3.3");

  src = fetchPypi {
    inherit pname version;
    sha256 = "6768e003d328a17011e6fca9126fbb8a6ffd3bb13cb21c450f3e724cca29abde";
  };

  postPatch = ''
    substituteInPlace theano/configdefaults.py \
      --replace 'StrParam(param, is_valid=warn_cxx)' 'StrParam('\'''${cxx_compiler}'\''', is_valid=warn_cxx)' \
      --replace 'rc == 0 and config.cxx != ""' 'config.cxx != ""'
  '' + stdenv.lib.optionalString cudaSupport ''
    substituteInPlace theano/configdefaults.py \
      --replace 'StrParam(get_cuda_root)' 'StrParam('\'''${cudatoolkit}'\''')'
  '' + stdenv.lib.optionalString cudnnSupport ''
    substituteInPlace theano/configdefaults.py \
      --replace 'StrParam(default_dnn_base_path)' 'StrParam('\'''${cudnn}'\''')'
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

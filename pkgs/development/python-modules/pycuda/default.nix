{ buildPythonPackage
, addOpenGLRunpath
, fetchPypi
, fetchFromGitHub
, Mako
, boost
, numpy
, pytools
, pytest
, decorator
, appdirs
, six
, cudatoolkit
, python
, mkDerivation
, lib
}:
let
  compyte = import ./compyte.nix {
    inherit mkDerivation fetchFromGitHub;
  };
in
buildPythonPackage rec {
  pname = "pycuda";
  version = "2021.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ab87312d0fc349d9c17294a087bb9615cffcf966ad7b115f5b051008a48dd6ed";
  };

  preConfigure = with lib.versions; ''
    ${python.interpreter} configure.py --boost-inc-dir=${boost.dev}/include \
                          --boost-lib-dir=${boost}/lib \
                          --no-use-shipped-boost \
                          --boost-python-libname=boost_python${major python.version}${minor python.version} \
                          --cuda-root=${cudatoolkit}
  '';

  postInstall = ''
    ln -s ${compyte} $out/${python.sitePackages}/pycuda/compyte
  '';

  postFixup = ''
    find $out/lib -type f \( -name '*.so' -or -name '*.so.*' \) | while read lib; do
      echo "setting opengl runpath for $lib..."
      addOpenGLRunpath "$lib"
    done
  '';

  # Requires access to libcuda.so.1 which is provided by the driver
  doCheck = false;

  checkPhase = ''
    py.test
  '';

  nativeBuildInputs = [
    addOpenGLRunpath
  ];

  propagatedBuildInputs = [
    numpy
    pytools
    pytest
    decorator
    appdirs
    six
    cudatoolkit
    compyte
    python
    Mako
  ];

  meta = with lib; {
    homepage = "https://github.com/inducer/pycuda/";
    description = "CUDA integration for Python.";
    license = licenses.mit;
    maintainers = with maintainers; [ artuuge ];
  };

}

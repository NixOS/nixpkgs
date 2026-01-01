{
  lib,
  buildPythonPackage,
  flit-core,
  cmake,
}:

buildPythonPackage {
  pname = "cmake";
  inherit (cmake) version;
  format = "pyproject";

  src = ./stub;

  postUnpack = ''
    substituteInPlace "$sourceRoot/pyproject.toml" \
      --subst-var version

    substituteInPlace "$sourceRoot/cmake/__init__.py" \
      --subst-var version \
      --subst-var-by CMAKE_BIN_DIR "${cmake}/bin"
  '';

  inherit (cmake) setupHooks;

  nativeBuildInputs = [ flit-core ];

  pythonImportsCheck = [ "cmake" ];

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "CMake is an open-source, cross-platform family of tools designed to build, test and package software";
    longDescription = ''
      This is a stub of the cmake package on PyPI that uses the cmake program
      provided by nixpkgs instead of downloading cmake from the web.
    '';
    homepage = "https://github.com/scikit-build/cmake-python-distributions";
<<<<<<< HEAD
    license = lib.licenses.asl20;
=======
    license = licenses.asl20;
    maintainers = with maintainers; [ tjni ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}

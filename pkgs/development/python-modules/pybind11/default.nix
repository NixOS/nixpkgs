{ stdenv
, lib
, buildPythonPackage
, fetchFromGitHub
, cmake
, boost
, eigen
, python
, catch
, numpy
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pybind11";
  version = "2.9.2";

  src = fetchFromGitHub {
    owner = "pybind";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-O3bkexUBa+gfiJEM6KSR8y/iVqHqlCFmz/9EghxdIpw=";
  };

  nativeBuildInputs = [ cmake ];

  dontUseCmakeBuildDir = true;

  cmakeFlags = [
    "-DBoost_INCLUDE_DIR=${lib.getDev boost}/include"
    "-DEIGEN3_INCLUDE_DIR=${lib.getDev eigen}/include/eigen3"
    "-DBUILD_TESTING=on"
  ] ++ lib.optionals (python.isPy3k && !stdenv.cc.isClang) [
    "-DPYBIND11_CXX_STANDARD=-std=c++17"
  ];

  postBuild = ''
    # build tests
    make -j $NIX_BUILD_CORES -l $NIX_BUILD_CORES
  '';

  postInstall = ''
    make install
    # Symlink the CMake-installed headers to the location expected by setuptools
    mkdir -p $out/include/${python.libPrefix}
    ln -sf $out/include/pybind11 $out/include/${python.libPrefix}/pybind11
  '';

  checkInputs = [
    catch
    numpy
    pytestCheckHook
  ];

  disabledTestPaths = [
    # require dependencies not available in nixpkgs
    "tests/test_embed/test_trampoline.py"
    "tests/test_embed/test_interpreter.py"
    # numpy changed __repr__ output of numpy dtypes
    "tests/test_numpy_dtypes.py"
    # no need to test internal packaging
    "tests/extra_python_package/test_files.py"
    # tests that try to parse setuptools stdout
    "tests/extra_setuptools/test_setuphelper.py"
  ];

  meta = with lib; {
    homepage = "https://github.com/pybind/pybind11";
    changelog = "https://github.com/pybind/pybind11/blob/${src.rev}/docs/changelog.rst";
    description = "Seamless operability between C++11 and Python";
    longDescription = ''
      Pybind11 is a lightweight header-only library that exposes
      C++ types in Python and vice versa, mainly to create Python
      bindings of existing C++ code.
    '';
    license = licenses.bsd3;
    maintainers = with maintainers; [ yuriaisaka dotlambda ];
  };
}

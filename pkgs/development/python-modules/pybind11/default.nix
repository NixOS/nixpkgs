{ stdenv
, lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, python
, pytest
, cmake
, catch
, numpy
, eigen
, scipy
}:

buildPythonPackage rec {
  pname = "pybind11";
  version = "2.4.3";

  src = fetchFromGitHub {
    owner = "pybind";
    repo = pname;
    rev = "v${version}";
    sha256 = "0k89w4bsfbpzw963ykg1cyszi3h3nk393qd31m6y46pcfxkqh4rd";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ catch ];

  cmakeFlags = [
    "-DEIGEN3_INCLUDE_DIR=${eigen}/include/eigen3"
  ] ++ lib.optionals (python.isPy3k && !stdenv.cc.isClang) [
  # Enable some tests only on Python 3. The "test_string_view" test
  # 'testTypeError: string_view16_chars(): incompatible function arguments'
  # fails on Python 2.
    "-DPYBIND11_CPP_STANDARD=-std=c++17"
  ];

  dontUseSetuptoolsBuild = true;
  dontUsePipInstall = true;
  dontUseSetuptoolsCheck = true;

  patches = [
    ./0001-Find-include-directory.patch
  ];

  postPatch = ''
    substituteInPlace pybind11/__init__.py --subst-var-by include "$out/include"
  '';

  preFixup = ''
    pushd ..
    export PYBIND11_USE_CMAKE=1
    setuptoolsBuildPhase
    pipInstallPhase
    # Symlink the CMake-installed headers to the location expected by setuptools
    mkdir -p $out/include/${python.libPrefix}
    ln -sf $out/include/pybind11 $out/include/${python.libPrefix}/pybind11
    popd
  '';

  checkInputs = [
    pytest
    numpy
    scipy
  ];

  meta = {
    homepage = https://github.com/pybind/pybind11;
    description = "Seamless operability between C++11 and Python";
    longDescription = ''
      Pybind11 is a lightweight header-only library that exposes
      C++ types in Python and vice versa, mainly to create Python
      bindings of existing C++ code.
    '';
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.yuriaisaka ];
  };
}

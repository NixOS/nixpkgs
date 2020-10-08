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
  version = "2.5.0";

  src = fetchFromGitHub {
    owner = "pybind";
    repo = pname;
    rev = "v${version}";
    sha256 = "13hcj6g7k7yvj7nry2ar6f5mg58ln7frrvq1cg5f8mczxh1ch6zl";
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

  meta = with lib; {
    homepage = "https://github.com/pybind/pybind11";
    description = "Seamless operability between C++11 and Python";
    longDescription = ''
      Pybind11 is a lightweight header-only library that exposes
      C++ types in Python and vice versa, mainly to create Python
      bindings of existing C++ code.
    '';
    license = licenses.bsd3;
    maintainers = with maintainers;[ yuriaisaka ];
  };
}

{ stdenv
, lib
, buildPythonPackage
, fetchFromGitHub
, cmake
, eigen
, python
, catch
, numpy
, pytest
}:

buildPythonPackage rec {
  pname = "pybind11";
  version = "2.8.0";

  src = fetchFromGitHub {
    owner = "pybind";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-kmyfRNZM9AtF0QA1MnWEPwWb6BebkkpanTvQwsraSJo=";
  };

  nativeBuildInputs = [ cmake ];

  dontUseCmakeBuildDir = true;

  cmakeFlags = [
    "-DEIGEN3_INCLUDE_DIR=${eigen}/include/eigen3"
    "-DBUILD_TESTING=on"
  ] ++ lib.optionals (python.isPy3k && !stdenv.cc.isClang) [
    "-DPYBIND11_CXX_STANDARD=-std=c++17"
  ];

  postBuild = ''
    # build tests
    make
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
    pytest
  ];

  checkPhase = ''
    runHook preCheck

    make check

    runHook postCheck
  '';

  meta = with lib; {
    homepage = "https://github.com/pybind/pybind11";
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

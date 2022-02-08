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
, pytest
}:

buildPythonPackage rec {
  pname = "pybind11";
  version = "2.9.0";

  src = fetchFromGitHub {
    owner = "pybind";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-zYDgXXpn8Z1Zti8Eje8qxDvbQV70/LmezG3AtxzDG+o=";
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

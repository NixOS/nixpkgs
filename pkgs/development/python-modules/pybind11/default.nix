{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, python
, pytest
, cmake
, numpy ? null
, eigen ? null
, scipy ? null
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

  dontUseCmakeConfigure = true;

  nativeBuildInputs = [ cmake ];
  checkInputs = [ pytest ]
    ++ (lib.optional (numpy != null) numpy)
    ++ (lib.optional (eigen != null) eigen)
    ++ (lib.optional (scipy != null) scipy);
  checkPhase = ''
    cmake ${if eigen != null then "-DEIGEN3_INCLUDE_DIR=${eigen}/include/eigen3" else ""}
    make -j $NIX_BUILD_CORES pytest
  '';

  # re-expose the headers to other packages
  postInstall = ''
    ln -s $out/include/python${python.pythonVersion}m/pybind11/ $out/include/pybind11
  '';

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

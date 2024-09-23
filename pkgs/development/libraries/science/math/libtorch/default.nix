{
  stdenv,
  cmake,
  eigen,
  python3,
  lib,
  python3Packages,
}:
stdenv.mkDerivation {
  src = builtins.fetchGit {
    url = "https://github.com/pytorch/pytorch";
    rev = "ea737e4e5d24774f7cebfae0c13933b4f148aba5";
    submodules = true;
  };
  name = "libtorch";
  nativeBuildInputs = [ cmake ];
  buildInputs = [
    eigen
    (python3.withPackages (ps: [
      ps.pyaml
      ps.typing-extensions
      ps.numpy
      ps.pybind11
      ps.six
      ps.setuptools
    ]))
  ];
  cmakeFlags = [
    (lib.cmakeFeature "PYTHON_SIX_SOURCE_DIR" "${python3Packages.six}")
    (lib.cmakeBool "USE_SYSTEM_EIGEN_INSTALL" true)
  ];
}

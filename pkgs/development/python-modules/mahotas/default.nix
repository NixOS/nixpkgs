{
  buildPythonPackage,
  fetchFromGitHub,
  pillow,
  scipy,
  numpy,
  pytestCheckHook,
  imread,
  lib,
  stdenv,
}:

buildPythonPackage rec {
  pname = "mahotas";
  version = "1.4.14";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "luispedro";
    repo = "mahotas";
    rev = "refs/tags/v${version}";
    hash = "sha256-9tjk3rhcfAYROZKwmwHzHAN7Ui0EgmxPErQyF//K0r8=";
  };

  propagatedBuildInputs = [
    imread
    numpy
    pillow
    scipy
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  # mahotas/_morph.cpp:864:10: error: no member named 'random_shuffle' in namespace 'std'
  env = lib.optionalAttrs stdenv.cc.isClang { NIX_CFLAGS_COMPILE = "-std=c++14"; };

  # tests must be run in the build directory
  preCheck = ''
    cd build/lib*
  '';

  # re-enable as soon as https://github.com/luispedro/mahotas/issues/97 is fixed
  disabledTests = [
    "test_colors"
    "test_ellipse_axes"
    "test_normalize"
    "test_haralick3d"
  ];

  pythonImportsCheck = [ "mahotas" ];

  disabled = stdenv.isi686; # Failing tests

  meta = with lib; {
    broken = (stdenv.isLinux && stdenv.isAarch64);
    description = "Computer vision package based on numpy";
    homepage = "https://mahotas.readthedocs.io/";
    maintainers = with maintainers; [ luispedro ];
    license = licenses.mit;
    platforms = platforms.unix;
  };
}

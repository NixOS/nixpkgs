{ buildPythonPackage
, fetchFromGitHub
, fetchpatch
, pillow
, scipy
, numpy
, pytestCheckHook
, imread
, freeimage
, lib
, stdenv
}:

buildPythonPackage rec {
  pname = "mahotas";
  version = "1.4.13";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "luispedro";
    repo = "mahotas";
    rev = "v${version}";
    hash = "sha256-AmctF/9hLgHw6FUm0s61eCdcc12lBa1t0OkXclis//w=";
  };

  propagatedBuildInputs = [
    freeimage
    imread
    numpy
    pillow
    scipy
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  postPatch = ''
    substituteInPlace mahotas/io/freeimage.py \
      --replace "ctypes.util.find_library('freeimage')" 'True' \
      --replace 'ctypes.CDLL(libname)' 'np.ctypeslib.load_library("libfreeimage", "${freeimage}/lib")'
  '';

  # mahotas/_morph.cpp:864:10: error: no member named 'random_shuffle' in namespace 'std'
  env = lib.optionalAttrs stdenv.cc.isClang {
    NIX_CFLAGS_COMPILE = "-std=c++14";
  };

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

  pythonImportsCheck = [
    "mahotas"
    "mahotas.freeimage"
  ];

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

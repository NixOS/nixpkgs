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

  src = fetchFromGitHub {
    owner = "luispedro";
    repo = "mahotas";
    rev = "v${version}";
    sha256 = "sha256-AmctF/9hLgHw6FUm0s61eCdcc12lBa1t0OkXclis//w=";
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

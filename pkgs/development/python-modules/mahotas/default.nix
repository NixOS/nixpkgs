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
  version = "1.4.11";

  src = fetchFromGitHub {
    owner = "luispedro";
    repo = "mahotas";
    rev = "v${version}";
    sha256 = "029gvy1fb855pvxvy8zwj44k4s7qpqi0161bg5wldfiprrysn1kw";
  };

  patches = [
    (fetchpatch {
      name = "fix-freeimage-tests.patch";
      url = "https://github.com/luispedro/mahotas/commit/08cc4aa0cbd5dbd4c37580d52b822810c03b2c69.patch";
      sha256 = "0389sz7fyl8h42phw8sn4pxl4wc3brcrj9d05yga21gzil9bfi23";
      excludes = [ "ChangeLog" ];
    })
  ];

  propagatedBuildInputs = [ numpy imread pillow scipy freeimage ];
  checkInputs = [ pytestCheckHook ];

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
    "test_uint16"
  ];

  pythonImportsCheck = [
    "mahotas"
    "mahotas.freeimage"
  ];

  disabled = stdenv.isi686; # Failing tests

  meta = with lib; {
    description = "Computer vision package based on numpy";
    homepage = "https://mahotas.readthedocs.io/";
    maintainers = with maintainers; [ luispedro ];
    license = licenses.mit;
    platforms = platforms.unix;
  };
}

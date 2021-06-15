{ buildPythonPackage, fetchFromGitHub, pillow, scipy, numpy, pytestCheckHook, imread, freeimage, lib, stdenv }:

buildPythonPackage rec {
  pname = "mahotas";
  version = "1.4.11";

  src = fetchFromGitHub {
    owner = "luispedro";
    repo = "mahotas";
    rev = "v${version}";
    sha256 = "029gvy1fb855pvxvy8zwj44k4s7qpqi0161bg5wldfiprrysn1kw";
  };

  propagatedBuildInputs = [ numpy imread pillow scipy freeimage ];
  checkInputs = [ pytestCheckHook ];

  postPatch = ''
    substituteInPlace mahotas/io/freeimage.py --replace "/opt/local/lib" "${freeimage}/lib"
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

  disabled = stdenv.isi686; # Failing tests

  meta = with lib; {
    description = "Computer vision package based on numpy";
    homepage = "https://mahotas.readthedocs.io/";
    maintainers = with maintainers; [ luispedro ];
    license = licenses.mit;
    platforms = platforms.unix;
  };
}

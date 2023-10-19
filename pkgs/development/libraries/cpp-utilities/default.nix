{ stdenv
, lib
, fetchFromGitHub
, cmake
, cppunit
, iconv
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cpp-utilities";
  version = "5.24.1";

  src = fetchFromGitHub {
    owner = "Martchus";
    repo = "cpp-utilities";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-Prb593+jXhYzwPHQnwen2qgaNfdX1Atiz1FhmXm9X7U=";
  };

  nativeBuildInputs = [ cmake ];
  nativeCheckInputs = [ cppunit ];
  buildInputs = lib.optionals stdenv.isDarwin [
    iconv # needed on Darwin, see https://github.com/Martchus/cpp-utilities/issues/4
  ];

  cmakeFlags = ["-DBUILD_SHARED_LIBS=ON"];

  # Otherwise, tests fail since the resulting shared object libc++utilities.so is only available in PWD of the make files
  preCheck = ''
    checkFlagsArray+=(
      "LD_LIBRARY_PATH=$PWD"
    )
  '';
  # tests fail on Darwin
  doCheck = !stdenv.isDarwin;

  meta = with lib; {
    homepage = "https://github.com/Martchus/cpp-utilities";
    description = "Common C++ classes and routines used by @Martchus' applications featuring argument parser, IO and conversion utilities";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ doronbehar ];
    platforms = platforms.linux ++ platforms.darwin;
  };
})

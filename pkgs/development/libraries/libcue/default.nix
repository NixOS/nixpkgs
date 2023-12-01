{ lib, stdenv, fetchFromGitHub, fetchpatch, cmake, bison, flex }:

stdenv.mkDerivation rec {
  pname = "libcue";
  version = "2.2.1";

  src = fetchFromGitHub {
    owner = "lipnitsk";
    repo = "libcue";
    rev = "v${version}";
    sha256 = "1iqw4n01rv2jyk9lksagyxj8ml0kcfwk67n79zy1r6zv1xfp5ywm";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2023-43641.patch";
      url = "https://github.com/lipnitsk/libcue/commit/fdf72c8bded8d24cfa0608b8e97f2eed210a920e.patch";
      hash = "sha256-NjnSMUfman/SwLFWDIhtz2jCOLfpXGGGjO3QwRGURNg=";
    })
  ];

  nativeBuildInputs = [ cmake bison flex ];

  doCheck = false; # fails all the tests (ctest)

  meta = with lib; {
    description = "CUE Sheet Parser Library";
    longDescription = ''
      libcue is intended to parse a so called cue sheet from a char string or
      a file pointer. For handling of the parsed data a convenient API is
      available.
    '';
    homepage = "https://github.com/lipnitsk/libcue";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ astsmtl ];
    platforms = platforms.unix;
  };
}

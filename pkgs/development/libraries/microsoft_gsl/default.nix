{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, cmake
, gtest
, pkg-config
}:

let
  nativeBuild = stdenv.hostPlatform == stdenv.buildPlatform;
in
stdenv.mkDerivation rec {
  pname = "microsoft_gsl";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "Microsoft";
    repo = "GSL";
    rev = "v${version}";
    sha256 = "0gbvr48f03830g3154bjhw92b8ggmg6wwh5xyb8nppk9v6w752l0";
  };

  patches = [
    (fetchpatch {
      name = "search-gtest-via-pkg-config.patch";
      url = "https://github.com/microsoft/GSL/commit/9355982fc5b64727c6506109f60cad25d272b18f.patch";
      sha256 = "1rhvrazrnjjydjy0gkabdj7x6616gymhmbyq3118s5nmp7rld70w";
    })
  ];

  nativeBuildInputs = [ cmake gtest pkg-config ];

  # build phase just runs the unit tests, so skip it if
  # we're doing a cross build
  dontBuild = !nativeBuild;

  meta = with lib; {
    description = "C++ Core Guideline support library";
    longDescription = ''
     The Guideline Support Library (GSL) contains functions and types that are suggested for
     use by the C++ Core Guidelines maintained by the Standard C++ Foundation.
     This package contains Microsoft's implementation of GSL.
    '';
    homepage    = "https://github.com/Microsoft/GSL";
    license     = licenses.mit;
    platforms   = platforms.all;
    maintainers = with maintainers; [ dotlambda thoughtpolice xwvvvvwx yuriaisaka ];
  };
}

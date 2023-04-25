{ lib
, stdenv
, fetchFromGitHub
, hash
, version
, patches

, cmake
, gtest
, fetchpatch
, pkg-config
}:

stdenv.mkDerivation rec {
  pname = "microsoft_gsl";
  inherit version;

  src = fetchFromGitHub {
    owner = "Microsoft";
    repo = "GSL";
    rev = "v${version}";
    inherit hash;
  };
  inherit patches;

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ gtest ];

  doCheck = true;

  meta = with lib; {
    description = "C++ Core Guideline support library";
    longDescription = ''
      The Guideline Support Library (GSL) contains functions and types that are suggested for
      use by the C++ Core Guidelines maintained by the Standard C++ Foundation.
      This package contains Microsoft's implementation of GSL.
    '';
    homepage = "https://github.com/Microsoft/GSL";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ thoughtpolice yuriaisaka ];
  };
}

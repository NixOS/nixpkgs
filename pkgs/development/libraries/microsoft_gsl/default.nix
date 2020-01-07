{ stdenv, fetchFromGitHub, catch, cmake
}:

let
  nativeBuild = stdenv.hostPlatform == stdenv.buildPlatform;
in
stdenv.mkDerivation rec {
  pname = "microsoft_gsl";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "Microsoft";
    repo = "GSL";
    rev = "v${version}";
    sha256 = "09f08lxqm00152bx9yrizlgabzpzxlpbv06h00z4w78yxywgxlgx";
  };

  # build phase just runs the unit tests, so skip it if
  # we're doing a cross build
  nativeBuildInputs = [ catch cmake ];
  buildPhase = if nativeBuild then "make" else "true";

  # https://github.com/microsoft/GSL/issues/806
  cmakeFlags = [ "-DCMAKE_CXX_FLAGS=-Wno-catch-value" ];

  installPhase = ''
    mkdir -p $out/include
    mv ../include/ $out/
  '';

  meta = with stdenv.lib; {
    description = "C++ Core Guideline support library";
    longDescription = ''
     The Guideline Support Library (GSL) contains functions and types that are suggested for
     use by the C++ Core Guidelines maintained by the Standard C++ Foundation.
     This package contains Microsoft's implementation of GSL.
    '';
    homepage    = "https://github.com/Microsoft/GSL";
    license     = licenses.mit;
    platforms   = platforms.all;
    maintainers = with maintainers; [ thoughtpolice xwvvvvwx yuriaisaka ];
  };
}

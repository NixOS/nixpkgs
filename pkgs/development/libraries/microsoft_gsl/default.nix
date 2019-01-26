{ stdenv, fetchgit, cmake
}:

let
  nativeBuild = stdenv.hostPlatform == stdenv.buildPlatform;
in
stdenv.mkDerivation rec {
  name = "microsoft_gsl-${version}";
  version = "2017-02-13";

  src = fetchgit {
    url = "https://github.com/Microsoft/GSL.git";
    rev = "3819df6e378ffccf0e29465afe99c3b324c2aa70";
    sha256 = "03d17mnx6n175aakin313308q14wzvaa9pd0m1yfk6ckhha4qf35";
  };


  # build phase just runs the unit tests, so skip it if
  # we're doing a cross build
  nativeBuildInputs = [ cmake ];
  buildPhase = if nativeBuild then "make" else "true";

  installPhase = ''
    mkdir -p $out/include
    mv ../include/ $out/
  '';

  meta = with stdenv.lib; {
    description = "Functions and types that are suggested for use by the C++ Core Guidelines";
    homepage    = https://github.com/Microsoft/GSL;
    license     = licenses.mit;
    platforms   = platforms.all;
    maintainers = with maintainers; [ thoughtpolice xwvvvvwx ];
  };
}

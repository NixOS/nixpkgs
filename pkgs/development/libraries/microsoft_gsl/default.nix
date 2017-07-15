{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  name = "microsoft_gsl-${version}";
  version = "2017-02-13";

  src = fetchFromGitHub {
    owner = "Microsoft";
    repo = "GSL";
    rev = "3819df6e378ffccf0e29465afe99c3b324c2aa70";
    sha256 = "1cmsm3ffcifwnaw7mi16k4y4fqi3q1sql09q8nqyxw1rhbf0n9jx";
  };

  # build phase just runs the unit tests
  buildInputs = [ cmake ];

  installPhase = ''
    mkdir -p $out/include
    mv ../include/ $out/
  '';

  meta = with stdenv.lib; {
    description = "Functions and types that are suggested for use by the C++ Core Guidelines";
    homepage = https://github.com/Microsoft/GSL;
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ xwvvvvwx ];
  };
}

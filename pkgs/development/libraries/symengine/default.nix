{ stdenv
, fetchFromGitHub
, cmake
, gmp
, flint
}:

stdenv.mkDerivation rec {
  name = "symengine-${version}";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "symengine";
    repo = "symengine";
    rev = "v${version}";
    sha256 = "1p7hk163rgn1zzvjlq4vskblry3s2rg5bc7xlr08wfqckfr47bqc";
  };

  buildInputs = [ cmake gmp flint ];

  cmakeFlags = [
    "-DWITH_FLINT=ON"
  ];

  doCheck = true;
  checkPhase = ''
    ctest
  '';

  meta = with stdenv.lib; {
    description = "SymEngine is a fast symbolic manipulation library";
    homepage = https://github.com/symengine/symengine;
    platforms = platforms.unix ++ platforms.windows;
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };

}

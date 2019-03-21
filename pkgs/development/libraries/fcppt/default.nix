{ stdenv, fetchFromGitHub, cmake, boost, brigand, catch2 }:

stdenv.mkDerivation rec {
  name = "fcppt-${version}";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "freundlich";
    repo = "fcppt";
    rev = version;
    sha256 = "0l78fjhy9nl3afrf0da9da4wzp1sx3kcyc2j6b71i60kvk44v4in";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ boost catch2 ];

  cmakeFlags = [ "-DENABLE_EXAMPLES=false" "-DENABLE_CATCH=true" "-DENABLE_TEST=true" "-DBrigand_INCLUDE_DIR=${brigand}/include" ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Freundlich's C++ toolkit";
    longDescription = ''
      Freundlich's C++ Toolkit (fcppt) is a collection of libraries focusing on
      improving general C++ code by providing better types, a strong focus on
      C++11 (non-conforming compilers are mostly not supported) and functional
      programming (which is both efficient and syntactically affordable in
      C++11).
    '';
    homepage = https://fcppt.org;
    license = licenses.boost;
    maintainers = with maintainers; [ pmiddend ];
    platforms = platforms.linux;
  };
}

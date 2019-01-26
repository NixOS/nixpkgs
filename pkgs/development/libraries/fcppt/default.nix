{ stdenv, fetchFromGitHub, cmake, boost, brigand }:

stdenv.mkDerivation rec {
  name = "fcppt-${version}";
  version = "2.9.0";

  src = fetchFromGitHub {
    owner = "freundlich";
    repo = "fcppt";
    rev = version;
    sha256 = "0zyqgmi1shjbwin1lx428v7vbi6jnywb1d47dascdn89r5gz6klv";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ boost ];

  cmakeFlags = [ "-DENABLE_EXAMPLES=false" "-DENABLE_TEST=false" "-DBrigand_INCLUDE_DIR=${brigand}/include" ];

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

{ stdenv, fetchgit, cmake, boost }:

stdenv.mkDerivation rec {
  name = "fcppt-1.3.0";

  src = fetchgit {
    url = https://github.com/freundlich/fcppt.git;
    rev = "7787733afc7a6278c0de8c0435b3d312e0c0c851";
    sha256 = "1vy6nhk6nymbp4yihvw75qn67q9fgmfc518f8dn3h2pq2gfjqrpy";
  };

  buildInputs = [ cmake boost ];

  cmakeFlags = [ "-DENABLE_EXAMPLES=false" "-DENABLE_TEST=false" ];

  enableParallelBuilding = true;

  meta = {
    description = "Freundlich's C++ toolkit";
    longDescription = ''
      Freundlich's C++ Toolkit (fcppt) is a collection of libraries focusing on
      improving general C++ code by providing better types, a strong focus on
      C++11 (non-conforming compilers are mostly not supported) and functional
      programming (which is both efficient and syntactically affordable in
      C++11).
    '';
    homepage = http://fcppt.org;
    license = stdenv.lib.licenses.boost;
    maintainers = with stdenv.lib.maintainers; [ pmiddend ];
    platforms = with stdenv.lib.platforms; linux;
  };
}

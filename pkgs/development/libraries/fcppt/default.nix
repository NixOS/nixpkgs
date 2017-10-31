{ stdenv, fetchFromGitHub, cmake, boost }:

stdenv.mkDerivation rec {
  name = "fcppt-${version}";
  version = "2.5.0";

  src = fetchFromGitHub {
    owner = "freundlich";
    repo = "fcppt";
    rev = version;
    sha256 = "0pjldwwxgnzjfd04cy29a9mn2szq4v2mjnw0367kxd141q2iglqi";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ boost ];

  cmakeFlags = [ "-DENABLE_EXAMPLES=false" "-DENABLE_TEST=false" ];

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
    homepage = http://fcppt.org;
    license = licenses.boost;
    maintainers = with maintainers; [ pmiddend ];
    platforms = platforms.linux;
  };
}

{stdenv, fetchurl, cmake}:

let
  v = "2.0.17";
in
stdenv.mkDerivation {
  name = "eigen-${v}";

  src = fetchurl {
    url = "http://bitbucket.org/eigen/eigen/get/${v}.tar.bz2";
    name = "eigen-${v}.tar.bz2";
    sha256 = "0q4ry2pmdb9lvm0g92wi6s6qng3m9q73n5flwbkfcz1nxmbfhmbj";
  };

  nativeBuildInputs = [ cmake ];

  meta = with stdenv.lib; {
    description = "C++ template library for linear algebra: vectors, matrices, and related algorithms";
    license = licenses.lgpl3Plus;
    homepage = http://eigen.tuxfamily.org ;
    maintainers = with stdenv.lib.maintainers; [ sander raskin ];
    branch = "2";
    platforms = with stdenv.lib.platforms; unix;
  };
}

{stdenv, fetchurl, cmake}:

let
  version = "3.2.10";
in
stdenv.mkDerivation {
  name = "eigen-${version}";
  
  src = fetchurl {
    url = "http://bitbucket.org/eigen/eigen/get/${version}.tar.gz";
    name = "eigen-${version}.tar.gz";
    sha256 = "00l52y7m276gh8wjkqqcxz6x687azrm7a70s3iraxnpy9bxa9y04";
  };
  
  nativeBuildInputs = [ cmake ];

  postInstall = ''
    sed -e '/Cflags:/s@''${prefix}@@' -i "$out"/share/pkgconfig/eigen3.pc
  '';
  
  meta = with stdenv.lib; {
    description = "C++ template library for linear algebra: vectors, matrices, and related algorithms";
    license = licenses.lgpl3Plus;
    homepage = http://eigen.tuxfamily.org ;
    platforms = platforms.unix;
    maintainers = with stdenv.lib.maintainers; [ sander urkud raskin ];
    inherit version;
  };
}

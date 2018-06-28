{stdenv, fetchurl, fetchpatch, cmake}:

let
  version = "3.3.4";
in
stdenv.mkDerivation {
  name = "eigen-${version}";
  
  src = fetchurl {
    url = "https://bitbucket.org/eigen/eigen/get/${version}.tar.gz";
    name = "eigen-${version}.tar.gz";
    sha256 = "1q85bgd6hnsgn0kq73wa4jwh4qdwklfg73pgqrz4zmxvzbqyi1j2";
  };

  patches = [
    # Remove for > 3.3.4
    # Upstream commit from 6 Apr 2018 "Fix cmake scripts with no fortran compiler"
    (fetchpatch {
      url    = "https://bitbucket.org/eigen/eigen/commits/ba14974d054ae9ae4ba88e5e58012fa6c2729c32/raw";
      sha256 = "0fskiy9sbzvp693fcyv3pfq8kxxx3d3mgmaqvjbl5bpfjivij8l1";
    })
  ];
  
  nativeBuildInputs = [ cmake ];

  postInstall = ''
    sed -e '/Cflags:/s@''${prefix}/@@' -i "$out"/share/pkgconfig/eigen3.pc
  '';
   
  meta = with stdenv.lib; {
    description = "C++ template library for linear algebra: vectors, matrices, and related algorithms";
    license = licenses.lgpl3Plus;
    homepage = http://eigen.tuxfamily.org ;
    platforms = platforms.unix;
    maintainers = with stdenv.lib.maintainers; [ sander raskin ];
    inherit version;
  };
}

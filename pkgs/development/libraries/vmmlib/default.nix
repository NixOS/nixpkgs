{ stdenv, fetchFromGitHub, cmake, pkgconfig, boost, blas }:

stdenv.mkDerivation rec {
  version = "1.6.2";
  name = "vmmlib-${version}";
  buildInputs = [ stdenv pkgconfig cmake boost blas ];

  src = fetchFromGitHub {
    owner = "VMML";
    repo = "vmmlib";
    rev = "release-${version}";
    sha256 = "0sn6jl1r5k6ka0vkjsdnn14hb95dqq8158dapby6jk72wqj9kdml";
  };

  patches = [ 
		./disable-cpack.patch   #disable the need of cpack/rpm
	    ];
  
  enableParallelBuilding = true;

  doCheck = true;

  checkTarget = "test";

  meta = with stdenv.lib; {
    description = "A vector and matrix math library implemented using C++ templates";

    longDescription = ''vmmlib is a vector and matrix math library implemented 
            using C++ templates. Its basic functionality includes a vector 
            and a matrix class, with additional functionality for the 
            often-used 3d and 4d vectors and 3x3 and 4x4 matrices.
            More advanced functionality include solvers, frustum 
            computations and frustum culling classes, and spatial data structures'';

    license     = licenses.bsd2;
    homepage    = http://github.com/VMML/vmmlib/;
    maintainers = [ maintainers.adev ];
    platforms   = platforms.all;
  };  
}


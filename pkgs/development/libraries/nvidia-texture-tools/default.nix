{ stdenv, fetchsvn, cmake, libpng, ilmbase, libtiff, zlib, libjpeg
, mesa, libX11
}:

stdenv.mkDerivation rec {
  # No support yet for cg, cuda, glew, glut, openexr.

  name = "nvidia-texture-tools";

  src = fetchsvn {
    url = "http://nvidia-texture-tools.googlecode.com/svn/trunk";
    rev = "1388";
    sha256 = "0pwxqx5l16nqidzm6mwd3rd4gbbknkz6q8cxnvf7sggjpbcvm2d6";
  };

  buildInputs = [ cmake libpng ilmbase libtiff zlib libjpeg mesa libX11 ];

  patchPhase = ''
    # Fix build due to missing dependnecies.
    echo 'target_link_libraries(bc7 nvmath)' >> src/nvtt/bc7/CMakeLists.txt
    echo 'target_link_libraries(bc6h nvmath)' >> src/nvtt/bc6h/CMakeLists.txt

    # Make a recently added pure virtual function just virtual,
    # to keep compatibility.
    sed -i 's/virtual void endImage() = 0;/virtual void endImage() {}/' src/nvtt/nvtt.h

    # Fix building shared libraries.
    sed -i 's/SET(NVIMAGE_SHARED TRUE)/SET(NVIMAGE_SHARED TRUE)\nSET(NVTHREAD_SHARED TRUE)/' CMakeLists.txt
  '';

  cmakeFlags = [
    "-DNVTT_SHARED=TRUE"
  ];

  meta = {
    description = "A set of cuda-enabled texture tools and compressors";
    homepage = "http://developer.nvidia.com/object/texture_tools.html";
    license = "MIT";
    platforms = stdenv.lib.platforms.linux;
  };
}

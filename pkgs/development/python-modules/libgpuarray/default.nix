{ stdenv
, lib
, buildPythonPackage
, fetchFromGitHub
, cmake
, cython
, numpy
, six
, nose
, Mako
, python
, cudaSupport ? false, cudatoolkit
, openclSupport ? true, ocl-icd, clblas
}:

buildPythonPackage rec {
  pname = "libgpuarray";
  version = "0.6.9";
  name = pname + "-" + version;

  src = fetchFromGitHub {
    owner = "Theano";
    repo = "libgpuarray";
    rev = "v${version}";
    sha256 = "06z47ls42a37gbv0x7f3l1qvils7q0hvy02s95l530klgibp19s0";
  };

  # requires a GPU
  doCheck = false;

  configurePhase = "cmakeConfigurePhase";

  libraryPath = lib.makeLibraryPath (
    []
    ++ lib.optionals cudaSupport [ cudatoolkit.lib cudatoolkit.out ]
    ++ lib.optionals openclSupport [ ocl-icd clblas ]
  );

  preBuild = ''
    make -j$NIX_BUILD_CORES
    make install

    ls $out/lib
    export NIX_CFLAGS_COMPILE="-L $out/lib -I $out/include $NIX_CFLAGS_COMPILE"

    cd ..
  '';

  postFixup = ''
    rm $out/lib/libgpuarray-static.a

    function fixRunPath {
      p=$(patchelf --print-rpath $1)
      patchelf --set-rpath "$p:$libraryPath" $1
    }

    fixRunPath $out/lib/libgpuarray.so
  '';

  propagatedBuildInputs = [
    numpy
    six
    Mako
  ];

  enableParallelBuilding = true;

  buildInputs = [
    cmake
    cython
    nose
  ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/Theano/libgpuarray";
    description = "Library to manipulate tensors on GPU.";
    license = licenses.free;
    maintainers = with maintainers; [ artuuge ];
    platforms = platforms.linux;
  };

}

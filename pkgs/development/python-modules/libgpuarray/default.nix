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
, cudaSupport ? false, cudatoolkit , nvidia_x11
, openclSupport ? true, ocl-icd, clblas
}:

assert cudaSupport -> nvidia_x11 != null
                   && cudatoolkit != null;

buildPythonPackage rec {
  pname = "libgpuarray";
  version = "0.7.5";

  src = fetchFromGitHub {
    owner = "Theano";
    repo = "libgpuarray";
    rev = "v${version}";
    sha256 = "0zkdwjq3k6ciiyf8y5w663fbsnmzhgy27yvpxfhkpxazw9vg3l5v";
  };

  # requires a GPU
  doCheck = false;

  configurePhase = "cmakeConfigurePhase";

  libraryPath = lib.makeLibraryPath (
    []
    ++ lib.optionals cudaSupport [ cudatoolkit.lib cudatoolkit.out nvidia_x11 ]
    ++ lib.optionals openclSupport ([ clblas ] ++ lib.optional (!stdenv.isDarwin) ocl-icd)
  );

  preBuild = ''
    make -j$NIX_BUILD_CORES
    make install

    export NIX_CFLAGS_COMPILE="-L $out/lib -I $out/include $NIX_CFLAGS_COMPILE"

    cd ..
  '';

  postFixup = ''
    rm $out/lib/libgpuarray-static.a
  '' + stdenv.lib.optionalString (!stdenv.isDarwin) ''
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

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    cython
    nose
  ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/Theano/libgpuarray";
    description = "Library to manipulate tensors on GPU.";
    license = licenses.free;
    maintainers = with maintainers; [ artuuge ];
    platforms = platforms.unix;
  };

}

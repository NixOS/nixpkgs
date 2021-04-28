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
  version = "0.7.6";

  src = fetchFromGitHub {
    owner = "Theano";
    repo = "libgpuarray";
    rev = "v${version}";
    sha256 = "0ksil18c9ign4xrv5k323flhvdy6wdxh8szdd3nivv31jc3zsdri";
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
  '' + lib.optionalString (!stdenv.isDarwin) ''
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

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    cython
    nose
  ];

  meta = with lib; {
    homepage = "https://github.com/Theano/libgpuarray";
    description = "Library to manipulate tensors on GPU.";
    license = licenses.free;
    maintainers = with maintainers; [ artuuge ];
    platforms = platforms.unix;
  };

}

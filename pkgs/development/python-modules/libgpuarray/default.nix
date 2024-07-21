{
  stdenv,
  lib,
  addOpenGLRunpath,
  buildPythonPackage,
  fetchFromGitHub,
  cmake,
  cython_0,
  numpy,
  six,
  nose,
  mako,
  config,
  cudaSupport ? config.cudaSupport,
  cudaPackages ? { },
  openclSupport ? true,
  ocl-icd,
  clblas,
}:

buildPythonPackage rec {
  pname = "libgpuarray";
  version = "0.7.6";
  format = "setuptools";

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
    lib.optionals cudaSupport (
      with cudaPackages;
      [
        cudatoolkit.lib
        cudatoolkit.out
      ]
    )
    ++ lib.optionals openclSupport ([ clblas ] ++ lib.optional (!stdenv.isDarwin) ocl-icd)
  );

  preBuild = ''
    make -j$NIX_BUILD_CORES
    make install

    export NIX_CFLAGS_COMPILE="-L $out/lib -I $out/include $NIX_CFLAGS_COMPILE"

    cd ..
  '';

  postFixup =
    ''
      rm $out/lib/libgpuarray-static.a
    ''
    + lib.optionalString (!stdenv.isDarwin) ''
      function fixRunPath {
        p=$(patchelf --print-rpath $1)
        patchelf --set-rpath "$p:$libraryPath" $1
      }

      fixRunPath $out/lib/libgpuarray.so
    ''
    + lib.optionalString cudaSupport ''
      addOpenGLRunpath $out/lib/libgpuarray.so
    '';

  propagatedBuildInputs = [
    numpy
    six
    mako
  ];

  nativeBuildInputs = [
    cmake
    cython_0
  ] ++ lib.optionals cudaSupport [ addOpenGLRunpath ];

  buildInputs = [ nose ];

  meta = with lib; {
    homepage = "https://github.com/Theano/libgpuarray";
    description = "Library to manipulate tensors on GPU";
    license = licenses.free;
    maintainers = with maintainers; [ artuuge ];
    platforms = platforms.unix;
  };
}

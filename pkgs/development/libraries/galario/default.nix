{ stdenv
, fetchzip
, fetchFromGitHub
, cmake
, fftw
, fftwFloat
, enablePython ? false
, pythonPackages
, llvmPackages
}:
let
  # CMake recipes are needed to build galario
  # Build process would usually download them
  great-cmake-cookoff = fetchzip {
    url = "https://github.com/UCL/GreatCMakeCookOff/archive/v2.1.9.tar.gz";
    sha256 = "1yd53b5gx38g6f44jmjk4lc4igs3p25z6616hfb7aq79ly01q0w2";
  };
in
stdenv.mkDerivation rec {
  pname = "galario";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "mtazzari";
    repo = pname;
    rev = "v${version}";
    sha256 = "1akz7md7ly16a89zr880c265habakqdg9sj8iil90klqa0i21w6g";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ fftw fftwFloat ]
    ++ stdenv.lib.optional enablePython pythonPackages.python
    ++ stdenv.lib.optional stdenv.isDarwin llvmPackages.openmp
  ;

  propagatedBuildInputs = stdenv.lib.optional enablePython [
    pythonPackages.numpy
    pythonPackages.cython
    pythonPackages.pytest
  ];

  checkInputs = stdenv.lib.optional enablePython pythonPackages.scipy;

  preConfigure = ''
    mkdir -p build/external/src
    cp -r ${great-cmake-cookoff} build/external/src/GreatCMakeCookOff
    chmod -R 777 build/external/src/GreatCMakeCookOff
  '';

  preCheck = ''
    ${if stdenv.isDarwin then "export DYLD_LIBRARY_PATH=$(pwd)/src/" else "export LD_LIBRARY_PATH=$(pwd)/src/"}
    ${if enablePython then "sed -i -e 's|^#!.*|#!${stdenv.shell}|' python/py.test.sh" else ""}
  '';

  doCheck = true;

  postInstall = stdenv.lib.optionalString (stdenv.isDarwin && enablePython) ''
    install_name_tool -change libgalario.dylib $out/lib/libgalario.dylib $out/lib/python*/site-packages/galario/double/libcommon.so
    install_name_tool -change libgalario_single.dylib $out/lib/libgalario_single.dylib $out/lib/python*/site-packages/galario/single/libcommon.so
  '';

  meta = with stdenv.lib; {
    description = "GPU Accelerated Library for Analysing Radio Interferometer Observations";
    longDescription = ''
      Galario is a library that exploits the computing power of modern
      graphic cards (GPUs) to accelerate the comparison of model
      predictions to radio interferometer observations. Namely, it
      speeds up the computation of the synthetic visibilities given a
      model image (or an axisymmetric brightness profile) and their
      comparison to the observations.
    '';
    homepage = "https://mtazzari.github.io/galario/";
    license = licenses.lgpl3;
    maintainers = [ maintainers.smaret ];
    platforms = platforms.all;
  };
}

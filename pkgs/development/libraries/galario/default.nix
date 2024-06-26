{
  lib,
  stdenv,
  fetchzip,
  fetchFromGitHub,
  cmake,
  fftw,
  fftwFloat,
  enablePython ? false,
  pythonPackages ? null,
  llvmPackages,
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
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "mtazzari";
    repo = pname;
    rev = "v${version}";
    sha256 = "0dw88ga50x3jwyfgcarn4azlhiarggvdg262hilm7rbrvlpyvha0";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs =
    [
      fftw
      fftwFloat
    ]
    ++ lib.optional enablePython pythonPackages.python
    ++ lib.optional stdenv.isDarwin llvmPackages.openmp;

  propagatedBuildInputs = lib.optionals enablePython [
    pythonPackages.numpy
    pythonPackages.cython
    pythonPackages.pytest
  ];

  nativeCheckInputs = lib.optionals enablePython [
    pythonPackages.scipy
    pythonPackages.pytest-cov
  ];

  preConfigure = ''
    mkdir -p build/external/src
    cp -r ${great-cmake-cookoff} build/external/src/GreatCMakeCookOff
    chmod -R 777 build/external/src/GreatCMakeCookOff
  '';

  preCheck = ''
    ${
      if stdenv.isDarwin then
        "export DYLD_LIBRARY_PATH=$(pwd)/src/"
      else
        "export LD_LIBRARY_PATH=$(pwd)/src/"
    }
    ${lib.optionalString enablePython "sed -i -e 's|^#!.*|#!${stdenv.shell}|' python/py.test.sh"}
  '';

  cmakeFlags = lib.optionals enablePython [
    # RPATH of binary /nix/store/.../lib/python3.10/site-packages/galario/double/libcommon.so contains a forbidden reference to /build/
    "-DCMAKE_SKIP_BUILD_RPATH=ON"
  ];

  doCheck = true;

  postInstall = lib.optionalString (stdenv.isDarwin && enablePython) ''
    install_name_tool -change libgalario.dylib $out/lib/libgalario.dylib $out/lib/python*/site-packages/galario/double/libcommon.so
    install_name_tool -change libgalario_single.dylib $out/lib/libgalario_single.dylib $out/lib/python*/site-packages/galario/single/libcommon.so
  '';

  meta = with lib; {
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

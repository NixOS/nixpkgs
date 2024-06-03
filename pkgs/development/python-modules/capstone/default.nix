{
  lib,
  buildPythonPackage,
  capstone,
  stdenv,
  setuptools,
  pythonAtLeast,
}:

buildPythonPackage rec {
  pname = "capstone";
  version = lib.getVersion capstone;
  format = "setuptools";

  # distutils usage
  disabled = pythonAtLeast "3.12";

  src = capstone.src;
  sourceRoot = "${src.name}/bindings/python";

  # libcapstone.a is not built with BUILD_SHARED_LIBS. For some reason setup.py
  # checks if it exists but it is not really needed. Most likely a bug in setup.py.
  postPatch = ''
    ln -s ${capstone}/lib/libcapstone${stdenv.targetPlatform.extensions.sharedLibrary} prebuilt/
    touch prebuilt/libcapstone${stdenv.targetPlatform.extensions.staticLibrary}
    substituteInPlace setup.py --replace manylinux1 manylinux2014
  '';

  # aarch64 only available from MacOS SDK 11 onwards, so fix the version tag.
  # otherwise, bdist_wheel may detect "macosx_10_6_arm64" which doesn't make sense.
  setupPyBuildFlags = lib.optionals (stdenv.isDarwin && stdenv.isAarch64) [
    "--plat-name"
    "macosx_11_0"
  ];

  propagatedBuildInputs = [ setuptools ];

  checkPhase = ''
    mv capstone capstone.hidden
    patchShebangs test_*
    make check
  '';

  meta = with lib; {
    homepage = "http://www.capstone-engine.org/";
    license = licenses.bsdOriginal;
    description = "Python bindings for Capstone disassembly engine";
    maintainers = with maintainers; [
      bennofs
      ris
    ];
  };
}

{
  lib,
  buildPythonPackage,
  capstone_4,
  stdenv,
  setuptools,
  fetchpatch,
}:

buildPythonPackage {
  pname = "capstone";
  inherit (capstone_4) version src;

  sourceRoot = "${capstone_4.src.name}/bindings/python";
  patches = [
    # Drop distutils in python binding (PR 2271)
    (fetchpatch {
      name = "drop-distutils-in-python-binding.patch";
      url = "https://github.com/capstone-engine/capstone/commit/d63211e3acb64fceb8b1c4a0d804b4b027f4ef71.patch";
      hash = "sha256-zUGeFmm3xH5dzfPJE8nnHwqwFBrsZ7w8LBJAy20/3RI=";
      stripLen = 2;
    })
  ];

  postPatch = ''
    ln -s ${capstone_4}/lib/libcapstone${stdenv.targetPlatform.extensions.sharedLibrary} prebuilt/
    ln -s ${capstone_4}/lib/libcapstone${stdenv.targetPlatform.extensions.staticLibrary} prebuilt/
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

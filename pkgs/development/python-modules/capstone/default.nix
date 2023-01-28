{ lib
, buildPythonPackage
, capstone
, stdenv
, setuptools
}:

buildPythonPackage rec {
  pname = "capstone";
  version = lib.getVersion capstone;

  src = capstone.src;
  sourceRoot = "source/bindings/python";

  postPatch = ''
    ln -s ${capstone}/lib/libcapstone${stdenv.targetPlatform.extensions.sharedLibrary} prebuilt/
    ln -s ${capstone}/lib/libcapstone.a prebuilt/
    substituteInPlace setup.py --replace manylinux1 manylinux2014
  '';

  # aarch64 only available from MacOS SDK 11 onwards, so fix the version tag.
  # otherwise, bdist_wheel may detect "macosx_10_6_arm64" which doesn't make sense.
  setupPyBuildFlags = lib.optionals (stdenv.isDarwin && stdenv.isAarch64) [ "--plat-name" "macosx_11_0" ];

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
    maintainers = with maintainers; [ bennofs ris ];
  };
}

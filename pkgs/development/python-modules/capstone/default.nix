{ lib
, buildPythonPackage
, capstone
, stdenv
, fetchpatch
, fetchPypi
, setuptools
}:

buildPythonPackage rec {
  pname = "capstone";
  version = lib.getVersion capstone;

  src = capstone.src;
  sourceRoot = "${capstone.name}/bindings/python";

  postPatch = ''
    ln -s ${capstone}/lib/libcapstone${stdenv.targetPlatform.extensions.sharedLibrary} prebuilt/
    ln -s ${capstone}/lib/libcapstone.a prebuilt/
    substituteInPlace setup.py --replace manylinux1 manylinux2014
  '';

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
    # creates a manylinux2014-x86_64 wheel
    broken = stdenv.isAarch64;
  };
}

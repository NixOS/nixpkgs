{ stdenv
, buildPythonPackage
, fetchPypi
, fetchpatch
, setuptools
, capstone
}:

buildPythonPackage rec {
  pname = "capstone";
  version = stdenv.lib.getVersion capstone;

  src = capstone.src;
  sourceRoot = "${capstone.name}/bindings/python";

  postPatch = ''
    ln -s ${capstone}/lib/libcapstone${stdenv.targetPlatform.extensions.sharedLibrary} prebuilt/
    ln -s ${capstone}/lib/libcapstone.a prebuilt/
  '';

  propagatedBuildInputs = [ setuptools ];

  checkPhase = ''
    mv capstone capstone.hidden
    patchShebangs test_*
    make check
  '';

  meta = with stdenv.lib; {
    homepage = "http://www.capstone-engine.org/";
    license = licenses.bsdOriginal;
    description = "Python bindings for Capstone disassembly engine";
    maintainers = with maintainers; [ bennofs ris ];
  };
}

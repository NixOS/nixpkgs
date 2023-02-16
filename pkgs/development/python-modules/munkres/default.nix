{ lib
, buildPythonPackage
, fetchPypi
, fetchpatch
, isPy3k
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "munkres";
  version = "1.1.4";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "fc44bf3c3979dada4b6b633ddeeb8ffbe8388ee9409e4d4e8310c2da1792db03";
  };

  patches = [
    # Fixes test on 32-bit systems.
    # Remove if https://github.com/bmc/munkres/pull/41 is merged.
    (fetchpatch {
      url = "https://github.com/bmc/munkres/commit/380a0d593a0569a761c4a035edaa4414c3b4b31d.patch";
      sha256 = "0ga63k68r2080blzi04ajdl1m6xd87mmlqa8hxn9hyixrg1682vb";
    })
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    homepage = "http://bmc.github.com/munkres/";
    description = "Munkres algorithm for the Assignment Problem";
    license = licenses.bsd3;
    maintainers = with maintainers; [ domenkozar ];
  };

}

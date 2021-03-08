{ lib, stdenv, buildPythonPackage, fetchPypi, isPyPy, pytestCheckHook, case, psutil, fetchpatch }:

buildPythonPackage rec {
  pname = "billiard";
  version = "3.6.3.0";
  disabled = isPyPy;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0spssl3byzqsplra166d59jx8iqfxyzvcbx7vybkmwr5ck72a5yr";
  };
  patches = [(fetchpatch {
    # Add Python 3.9 support to spawnv_passfds()
    # Should be included in next release after 3.6.3.0
    url = "https://github.com/celery/billiard/pull/310/commits/a508ebafadcfe2e25554b029593f3e66d01ede6c.patch";
    sha256 = "05zsr1bvjgi01qg7r274c0qvbn65iig3clyz14c08mpfyn38h84i";
    excludes = [ "tox.ini" ];
  })];

  checkInputs = [ pytestCheckHook case psutil ];

  meta = with lib; {
    homepage = "https://github.com/celery/billiard";
    description = "Python multiprocessing fork with improvements and bugfixes";
    license = licenses.bsd3;
  };
}

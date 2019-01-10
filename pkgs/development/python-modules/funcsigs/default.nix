{ stdenv, buildPythonPackage, fetchPypi, fetchpatch
, unittest2 }:

buildPythonPackage rec {
  pname = "funcsigs";
  version = "1.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0l4g5818ffyfmfs1a924811azhjj8ax9xd1cffr1mzd3ycn0zfx7";
  };
  
  patches = [
    (fetchpatch {
      url = "https://raw.githubusercontent.com/gentoo/gentoo/fd9a5a0a3c15d7400b936ce0f0814fd4078e900c/dev-python/funcsigs/files/funcsigs-1.0.2-fix-pypy3-tests.patch";
      sha256 = "04pqkgglqxdkvq07mbr21zlijwiw8jarrb10r4d4yxr3swn3zsl6";
    })
  ];

  buildInputs = [ unittest2 ];

  meta = with stdenv.lib; {
    description = "Python function signatures from PEP362 for Python 2.6, 2.7 and 3.2+";
    homepage = https://github.com/aliles/funcsigs;
    maintainers = with maintainers; [ garbas ];
    license = licenses.asl20;
  };
}

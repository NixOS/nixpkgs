{ lib
, buildPythonPackage
, fetchPypi
, isPyPy
, fetchpatch
}:

buildPythonPackage rec {
  pname = "random2";
  version = "1.0.1";
  format = "setuptools";
  doCheck = !isPyPy;

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "34ad30aac341039872401595df9ab2c9dc36d0b7c077db1cea9ade430ed1c007";
  };

  patches = [
    # Patch test suite for python >= 3.9
    (fetchpatch {
      url = "https://github.com/strichter/random2/pull/3/commits/1bac6355d9c65de847cc445d782c466778b94fbd.patch";
      sha256 = "064137pg1ilv3f9r10123lqbqz45070jca8pjjyp6gpfd0yk74pi";
    })
  ];

  meta = with lib; {
    homepage = "http://pypi.python.org/pypi/random2";
    description = "Python 3 compatible Python 2 `random` Module";
    license = licenses.psfl;
  };

}

{
  lib,
  buildPythonPackage,
  fetchPypi,
  isPyPy,
  fetchpatch,
}:

buildPythonPackage rec {
  pname = "random2";
  version = "1.0.1";
  format = "setuptools";
  doCheck = !isPyPy;

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    hash = "sha256-NK0wqsNBA5hyQBWV35qyydw20LfAd9sc6preQw7RwAc=";
  };

  patches = [
    # Patch test suite for python >= 3.9
    (fetchpatch {
      url = "https://github.com/strichter/random2/pull/3/commits/1bac6355d9c65de847cc445d782c466778b94fbd.patch";
      hash = "sha256-8ZIzPWjuPnO9lBcpJsEBhXy8MB0igJCTG5vG8O4ZgRg=";
    })
  ];

  meta = {
    homepage = "http://pypi.org/pypi/random2/";
    description = "Python 3 compatible Python 2 `random` Module";
    license = lib.licenses.psfl;
  };
}

{ lib
, buildPythonPackage
, fetchPypi
, fetchpatch
, python
, pythonOlder
, pytest
}:

buildPythonPackage rec {
  pname = "mock";
  version = "4.0.3";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7d3fbbde18228f4ff2f1f119a45cdffa458b4c0dee32eb4d2bb2f82554bac7bc";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/testing-cabal/mock/commit/f3e3d82aab0ede7e25273806dc0505574d85eae2.patch";
      sha256 = "sha256-wPrv1/WeICZHn31UqFlICFsny2knvn3+Xg8BZoaGbwQ=";
    })
  ];

  checkPhase = ''
    ${python.interpreter} -m unittest discover
  '';

  checkInputs = [
    pytest
  ];

  meta = with lib; {
    description = "Mock objects for Python";
    homepage = "https://github.com/testing-cabal/mock";
    license = licenses.bsd2;
  };
}

{ lib, fetchPypi, buildPythonPackage, isPy3k, solc, semantic-version }:

buildPythonPackage rec {
  pname = "py-solc";
  version = "3.2.0";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "16lcxz9yhhv0w9dj4ayr611nf9dnpnb8mbrdrx42y1v1qvd5n2c2";
  };

  postPatch = ''
    substituteInPlace setup.py --replace "setup_requires=['setuptools-markdown']," ""
  '';

  propagatedBuildInputs = [ solc semantic-version ];

  # checks are disabled because test suite seem to be broken:
  # see here: https://github.com/ethereum/py-solc/issues/60
  doCheck = false;

  meta = with lib; {
    description = "Python wrapper around the solc binary";
    license = licenses.mit;
    maintainers = [ maintainers.paulperegud ];
  };
}

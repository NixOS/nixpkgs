{ lib
, buildPythonPackage
, fetchPypi
, cryptography
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "PyJWT";
  version = "2.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b888b4d56f06f6dcd777210c334e69c737be74755d3e5e9ee3fe67dc18a0ee41";
  };

  postPatch = ''
    substituteInPlace setup.py --replace "pytest>=4.0.1,<5.0.0" "pytest"

    # drop coverage
    sed -i '/pytest-cov/d' setup.py
    sed -i '/--cov/d' setup.cfg
  '';

  propagatedBuildInputs = [
    cryptography
  ];

  checkInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "JSON Web Token implementation in Python";
    homepage = "https://github.com/jpadilla/pyjwt";
    license = licenses.mit;
  };
}

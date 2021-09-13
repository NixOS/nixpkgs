{ lib
, buildPythonPackage
, fetchPypi
, cryptography
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "PyJWT";
  version = "2.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "fba44e7898bbca160a2b2b501f492824fc8382485d3a6f11ba5d0c1937ce6130";
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

{ lib
, buildPythonPackage
, fetchPypi
, cryptography
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "PyJWT";
  version = "1.7.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "15hflax5qkw1v6nssk1r0wkj83jgghskcmn875m3wgvpzdvajncd";
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

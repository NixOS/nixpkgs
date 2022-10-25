{ lib
, buildPythonPackage
, fetchPypi
, cryptography
, pytestCheckHook
, pythonOlder
, sphinxHook
, sphinx-rtd-theme
, zope-interface
}:

buildPythonPackage rec {
  pname = "pyjwt";
  version = "2.5.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "PyJWT";
    inherit version;
    sha256 = "sha256-53q4lICQXYaZhEKsV4jzUzP6hfZQR6U0rcOO3zyI/Ds=";
  };

  postPatch = ''
    sed -i '/types-cryptography/d' setup.cfg
  '';

  outputs = [
    "out"
    "doc"
  ];

  nativeBuildInputs = [
    sphinxHook
    sphinx-rtd-theme
    zope-interface
  ];

  passthru.optional-dependencies.crypto = [
    cryptography
  ];

  checkInputs = [
    pytestCheckHook
  ] ++ (lib.flatten (lib.attrValues passthru.optional-dependencies));

  pythonImportsCheck = [ "jwt" ];

  meta = with lib; {
    description = "JSON Web Token implementation in Python";
    homepage = "https://github.com/jpadilla/pyjwt";
    license = licenses.mit;
    maintainers = with maintainers; [ prikhi ];
  };
}

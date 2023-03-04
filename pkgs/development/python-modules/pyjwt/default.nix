{ lib
, buildPythonPackage
, fetchPypi
, cryptography
, pytestCheckHook
, pythonOlder
, sphinxHook
, sphinx-rtd-theme
, zope_interface
}:

buildPythonPackage rec {
  pname = "pyjwt";
  version = "2.6.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "PyJWT";
    inherit version;
    hash = "sha256-aShcfjH8RPaKH+swnpSODfUyWdV5KV5s/isXkjKfBf0=";
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
    zope_interface
  ];

  passthru.optional-dependencies.crypto = [
    cryptography
  ];

  nativeCheckInputs = [
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

{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, cryptography
, pytestCheckHook
, pythonOlder
, sphinxHook
, sphinx-rtd-theme
, zope-interface
}:

buildPythonPackage rec {
  pname = "pyjwt";
  version = "2.8.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "PyJWT";
    inherit version;
    hash = "sha256-V+KNFW49XBAIjgxoq7kL+sPfgrQKcb0NqiDGXM1cI94=";
  };

  postPatch = ''
    sed -i '/types-cryptography/d' setup.cfg
  '';

  outputs = [
    "out"
    "doc"
  ];

  nativeBuildInputs = [
    setuptools
    sphinxHook
    sphinx-rtd-theme
    zope-interface
  ];

  passthru.optional-dependencies.crypto = [
    cryptography
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ] ++ (lib.flatten (lib.attrValues passthru.optional-dependencies));

  disabledTests = [
    # requires internet connection
    "test_get_jwt_set_sslcontext_default"
  ];

  pythonImportsCheck = [ "jwt" ];

  meta = with lib; {
    changelog = "https://github.com/jpadilla/pyjwt/blob/${version}/CHANGELOG.rst";
    description = "JSON Web Token implementation in Python";
    homepage = "https://github.com/jpadilla/pyjwt";
    license = licenses.mit;
    maintainers = with maintainers; [ prikhi ];
  };
}

{ lib
, buildPythonPackage
, fetchPypi
, fetchpatch
, cryptography
, ecdsa
, pytest-cov
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pyjwt";
  version = "2.3.0";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    pname = "PyJWT";
    inherit version;
    sha256 = "sha256-uIi01W8G9tzXdyEMM05pxze+dHVdPl6e4/5n3Big7kE=";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2022-29217.patch";
      url = "https://github.com/jpadilla/pyjwt/commit/9c528670c455b8d948aff95ed50e22940d1ad3fc.patch";
      excludes = [
        ".gitignore"
        "jwt/__init__.py" # changes version
      ];
      hash = "sha256-9fgCn2Pb3q72c4w5utP16KhDsAe50EnHd7Z57Zrj7wA=";
    })
  ];

  propagatedBuildInputs = [
    cryptography
    ecdsa
  ];

  checkInputs = [
    pytest-cov
    pytestCheckHook
  ];

  pythonImportsCheck = [ "jwt" ];

  meta = with lib; {
    description = "JSON Web Token implementation in Python";
    homepage = "https://github.com/jpadilla/pyjwt";
    license = licenses.mit;
    maintainers = with maintainers; [ prikhi ];
  };
}

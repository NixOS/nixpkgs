{ lib
, buildPythonPackage
, fetchPypi
, fetchpatch
, cryptography
, deprecated
, pythonOlder
}:

buildPythonPackage rec {
  pname = "jwcrypto";
  version = "1.5.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-SLub9DN3cTYlNXnlK3X/4PmkpyHRM9AfRaC5HtX08a4=";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2024-28102.patch";
      url = "https://github.com/latchset/jwcrypto/commit/90477a3b6e73da69740e00b8161f53fea19b831f.patch";
      hash = "sha256-0+zjHEXEcL1ZqRaxFi3lo9nAg+Ny/ERpNCclF+0SrYI=";
    })
  ];

  propagatedBuildInputs = [
    cryptography
    deprecated
  ];

  pythonImportsCheck = [
    "jwcrypto"
  ];

  meta = with lib; {
    description = "Implementation of JOSE Web standards";
    homepage = "https://github.com/latchset/jwcrypto";
    changelog = "https://github.com/latchset/jwcrypto/releases/tag/v${version}";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ ];
  };
}

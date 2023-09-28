{ lib
, buildPythonPackage
, fetchpatch
, fetchPypi
, psutil
, py
, pytest
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "pytest-xprocess";
  version = "0.22.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-WZ7iW5OOjyWeGNnFtNY4SIT4pqKMpR7tMtDZUmvc93w=";
  };

  patches = [
    (fetchpatch {
      name = "remove-py-dep.patch";
      url = "https://github.com/pytest-dev/pytest-xprocess/commit/125ddccd46645cf259fdb499ec45d66d5acc3230.patch";
      hash = "sha256-hb3Lg3Kvnb+kBPZ2MQU9lWKfh1RaVsgkZbMrTOFX6vA=";
    })
  ];

  postPatch = ''
    # Remove test QoL package from install_requires
    substituteInPlace setup.py \
      --replace "'pytest-cache', " ""
  '';

  nativeBuildInputs = [
    setuptools-scm
  ];

  buildInputs = [
    pytest
  ];

  propagatedBuildInputs = [
    psutil
    py
  ];

  # There's no tests in repo
  doCheck = false;

  pythonImportsExtrasCheck = [
    "xprocess"
  ];

  meta = with lib; {
    description = "Pytest external process plugin";
    homepage = "https://github.com/pytest-dev";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}

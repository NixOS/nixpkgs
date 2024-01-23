{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "pathvalidate";
  version = "3.2.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-XoN4z2cSv/Z/vnqDB9mfqMGgyyiqR3BW+Pw3Tw3/JK0=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  # Requires `pytest-md-report`, causing infinite recursion.
  doCheck = false;

  pythonImportsCheck = [
    "pathvalidate"
  ];

  meta = with lib; {
    description = "Library to sanitize/validate a string such as filenames/file-paths/etc";
    homepage = "https://github.com/thombashi/pathvalidate";
    changelog = "https://github.com/thombashi/pathvalidate/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ oxalica ];
  };
}

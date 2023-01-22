{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, construct
, pytestCheckHook
}:

buildPythonPackage rec {
  pname   = "construct-classes";
  version = "0.1.2";
  format = "pyproject";

  # no tests in PyPI tarball
  src = fetchFromGitHub {
    owner  = "matejcik";
    repo   = "construct-classes";
    rev    = "v${version}";
    sha256 = "sha256-l4sVacKTuQbhXCw2lVHCl1OzpCiKmEAm9nSQ8pxFuTo=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    construct
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "construct_classes" ];

  meta = with lib; {
    description = "Parse your binary data into dataclasses.";
    homepage = "https://github.com/matejcik/construct-classes";
    license = licenses.mit;
    maintainers = with maintainers; [ prusnak ];
  };
}

{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, setuptools
}:

buildPythonPackage rec {
  pname = "merge3";
  version = "0.0.13";

  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8abda1d2d49776323d23d09bfdd80d943a57d43d28d6152ffd2c87956a9b6b54";
  };

  nativeBuildInputs = [
    setuptools
  ];

  pythonImportsCheck = [
    "merge3"
  ];

  meta = with lib; {
    description = "Python implementation of 3-way merge";
    homepage = "https://github.com/breezy-team/merge3";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ marsam ];
  };
}

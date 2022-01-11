{ lib, buildPythonPackage, fetchPypi, future, configparser, isPy27 }:

buildPythonPackage rec {
  pname = "arabic_reshaper";
  version = "2.1.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a236fc6e9dde2a61cc6a5ca962b522e42694e1bb2a2d86894ed7a4eba4ce1890";
  };

  propagatedBuildInputs = [ future ]
    ++ lib.optionals isPy27 [ configparser ];

  # Tests are not published on pypi
  doCheck = false;

  pythonImportsCheck = [ "arabic_reshaper" ];

  meta = with lib; {
    homepage = "https://github.com/mpcabd/python-arabic-reshaper";
    description = "Reconstruct Arabic sentences to be used in applications that don't support Arabic";
    platforms = platforms.unix;
    maintainers = with maintainers; [ freezeboy ];
  };
}

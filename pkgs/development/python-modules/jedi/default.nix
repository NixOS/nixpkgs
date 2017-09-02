{ lib
, buildPythonPackage
, fetchPypi
, pytest
, glibcLocales
}:

buildPythonPackage rec {
  pname = "jedi";
  version = "0.10.2";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7abb618cac6470ebbd142e59c23daec5e6e063bfcecc8a43a037d2ab57276f4e";
  };

  checkInputs = [ pytest glibcLocales ];

  checkPhase = ''
    LC_ALL="en_US.UTF-8" py.test test
  '';

  # 7 failed
  #doCheck = false;

  meta = {
    homepage = https://github.com/davidhalter/jedi;
    description = "An autocompletion tool for Python that can be used for text editors";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ garbas ];
  };
}

{ lib
, buildPythonPackage
, fetchpatch
, fetchPypi
, pytestCheckHook
, setuptools
, setuptools-scm
, wheel
}:

buildPythonPackage rec {
  pname = "ansi2html";
  version = "1.8.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-OLgqKYSCofomE/D5yb6z23Ko+DLurFjrLke/Ms039tU=";
  };

  patches = [
    (fetchpatch {
      name = "update-build-requirements.patch";
      url = "https://github.com/pycontribs/ansi2html/commit/be9c47dd39e500b2e34e95efde90d0a3b44daaee.patch";
      hash = "sha256-nvOclsgysg+4sK694ppls0BLfq5MCJJQW3V/Ru30D/k=";
    })
  ];

  nativeBuildInputs = [
    setuptools
    setuptools-scm
    wheel
  ];

  preCheck = "export PATH=$PATH:$out/bin";

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "ansi2html" ];

  meta = with lib; {
    description = "Convert text with ANSI color codes to HTML";
    homepage = "https://github.com/ralphbean/ansi2html";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ davidtwco ];
  };
}

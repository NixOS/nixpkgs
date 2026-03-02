{
  lib,
  buildPythonPackage,
  fetchPypi,
  glibcLocales,
  python,
  tqdm,
}:

buildPythonPackage (finalAttrs: {
  pname = "pypdf3";
  version = "1.0.6";
  format = "setuptools";

  src = fetchPypi {
    pname = "PyPDF3";
    inherit (finalAttrs) version;
    hash = "sha256-yUbzJzQZ43JY415yJz9JkEqxVyPYenYcERXvmXmfjF8=";
  };

  env.LC_ALL = "en_US.UTF-8";
  buildInputs = [ glibcLocales ];

  checkPhase = ''
    ${python.interpreter} -m unittest tests/*.py
  '';

  propagatedBuildInputs = [ tqdm ];

  meta = {
    description = "Pure-Python library built as a PDF toolkit";
    homepage = "https://github.com/sfneal/PyPDF3";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ ambroisie ];
  };
})

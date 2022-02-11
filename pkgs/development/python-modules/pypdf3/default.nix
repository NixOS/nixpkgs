{ lib
, buildPythonPackage
, fetchPypi
, glibcLocales
, python
, tqdm
}:

buildPythonPackage rec {
  pname = "pypdf3";
  version = "1.0.5";

  src = fetchPypi {
    pname = "PyPDF3";
    inherit version;
    sha256 = "sha256-DGKpR4p3z8tw4gKi5Hmj09svysD3Hkn4NklhgROmEAU=";
  };

  LC_ALL = "en_US.UTF-8";
  buildInputs = [ glibcLocales ];

  checkPhase = ''
    ${python.interpreter} -m unittest tests/*.py
  '';

  propagatedBuildInputs = [
    tqdm
  ];

  meta = with lib; {
    description = "A Pure-Python library built as a PDF toolkit";
    homepage = "https://github.com/sfneal/PyPDF3";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ambroisie ];
  };
}

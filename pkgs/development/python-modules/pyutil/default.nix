{ lib
, buildPythonPackage
, fetchPypi
, simplejson
, mock
, twisted
, isPyPy
}:

buildPythonPackage rec {
  pname = "pyutil";
  version = "3.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8c4d4bf668c559186389bb9bce99e4b1b871c09ba252a756ccaacd2b8f401848";
  };

  propagatedBuildInputs = [ simplejson ];

  nativeCheckInputs = [ mock twisted ];

  prePatch = lib.optionalString isPyPy ''
    grep -rl 'utf-8-with-signature-unix' ./ | xargs sed -i -e "s|utf-8-with-signature-unix|utf-8|g"
  '';

  meta = with lib; {
    description = "Pyutil, a collection of mature utilities for Python programmers";

    longDescription = ''
      These are a few data structures, classes and functions which
      we've needed over many years of Python programming and which
      seem to be of general use to other Python programmers. Many of
      the modules that have existed in pyutil over the years have
      subsequently been obsoleted by new features added to the
      Python language or its standard library, thus showing that
      we're not alone in wanting tools like these.
    '';

    homepage = "https://github.com/tpltnt/pyutil";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ prusnak ];
  };

}

{ buildPythonPackage
, fetchPypi
, isPy3k
, isPy35
# NOTE: PyPy would not be compatible with
# SIP (a PyQt5 dependency) and MatPlotLib
, isPyPy
, lib
, numpy
, pyqt5
}:
let
  pickRequiredDeps = (ps: with ps; [
    numpy
    pyqt5
    ]);
  pickOptionalDeps = (ps: with ps; [
    matplotlib
    pyenchant
  ]);
  requiredPythonDependencies = [
    numpy
    pyqt5
  ];
in
buildPythonPackage rec {
  pname = "pyspread";
  version = "1.99.5";

  passthru = {
    inherit version;
    inherit pickRequiredDeps pickOptionalDeps;
  };

  src = fetchPypi {
    inherit pname version;
    sha256 = "d396c2f94bf1ef6140877ab19205e6f2375bfe01d1bf50ff33bb63384744dd78";
  };

  propagatedBuildInputs = requiredPythonDependencies;

  # Tests try to access X Display
  doCheck = false;

  disabled = (!isPy3k) || isPy35;

  postInstall = ''
    executerName=$(head -n 1 "$out/bin/pyspread" | sed -r '1 s/#!(\/usr)?\/bin\/(\S+)(.*)$/\2/')
    if test executerName != "env"; then
      sed -i -r '1 s/#!(\/usr)?\/bin\/(\S+)(.*)$/#!\/usr\/bin\/env \2/' "$out/bin/pyspread"
    else
      sed -i -r '1 s/#!(\/usr)?\/bin\/(\S+)(.*)$/#!\/usr\/bin\/env\3/' "$out/bin/pyspread"
    fi
  '' + (lib.strings.optionalString isPyPy ''
    sed -i -r 's/python([0-9]*m?\s+)-m/pypy\1-m/' $out/bin/pyspread
  '');

  meta = with lib; {
    description = "API of PySpread, a non-traditional spreadsheet application that is based on and written in the programming language Python";
    longDescription = ''
      This is the API of PySpread, and is meant to be
      imported in a python script
      instead of installing into user profiles,
      as the execution script has not been properly wrapped
      and won't run out of the box.
    '';
    homepage = "https://pyspread.gitlab.io/pyspread/";
    license = licenses.gpl3;
  };
}

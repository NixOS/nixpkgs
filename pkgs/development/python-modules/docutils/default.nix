{ stdenv
, lib
, fetchPypi
, buildPythonPackage
, isPy3k
, isPy38
, python
}:

buildPythonPackage rec {
  pname = "docutils";
  version = "0.15.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "168s5v7bff5ar9jspr6wn823q1sbn0jhnbp9clk41nl8j09fmbm2";
  };

  # Only Darwin needs LANG, but we could set it in general.
  # It's done here conditionally to prevent mass-rebuilds.
  checkPhase = lib.optionalString (isPy3k && stdenv.isDarwin) ''LANG="en_US.UTF-8" LC_ALL="en_US.UTF-8" '' + (if isPy3k then ''
    ${python.interpreter} test3/alltests.py
  '' else ''
    ${python.interpreter} test/alltests.py
  '');

  # Create symlinks lacking a ".py" suffix, many programs depend on these names
  postFixup = ''
    for f in $out/bin/*.py; do
      ln -s $(basename $f) $out/bin/$(basename $f .py)
    done
  '';

  # Four tests are broken with 3.8.
  # test_writers.test_odt.DocutilsOdtTestCase
  doCheck = !isPy38;

  meta = {
    description = "Docutils -- Python Documentation Utilities";
    homepage = http://docutils.sourceforge.net/;
    maintainers = with lib.maintainers; [ AndersonTorres ];
  };
}

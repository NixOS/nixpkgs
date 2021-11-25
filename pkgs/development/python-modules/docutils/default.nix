{ stdenv
, lib
, fetchPypi
, buildPythonPackage
, isPy3k
, python
}:

buildPythonPackage rec {
  pname = "docutils";
  version = "0.18.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "679987caf361a7539d76e584cbeddc311e3aee937877c87346f31debc63e9d06";
  };

  # Only Darwin needs LANG, but we could set it in general.
  # It's done here conditionally to prevent mass-rebuilds.
  checkPhase = lib.optionalString (isPy3k && stdenv.isDarwin) ''LANG="en_US.UTF-8" LC_ALL="en_US.UTF-8" '' + ''
    ${python.interpreter} test/alltests.py
  '';

  # Create symlinks lacking a ".py" suffix, many programs depend on these names
  postFixup = ''
    for f in $out/bin/*.py; do
      ln -s $(basename $f) $out/bin/$(basename $f .py)
    done
  '';

  meta = with lib; {
    description = "Python Documentation Utilities";
    homepage = "http://docutils.sourceforge.net/";
    license = with licenses; [ publicDomain bsd2 psfl gpl3Plus ];
    maintainers = with maintainers; [ AndersonTorres ];
  };
}

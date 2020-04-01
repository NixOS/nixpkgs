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
  version = "0.16";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c2de3a60e9e7d07be26b7f2b00ca0309c207e06c100f9cc2a94931fc75a478fc";
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

  meta = {
    description = "Docutils -- Python Documentation Utilities";
    homepage = http://docutils.sourceforge.net/;
    maintainers = with lib.maintainers; [ AndersonTorres ];
  };
}

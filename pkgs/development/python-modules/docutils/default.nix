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
  version = "0.17.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "686577d2e4c32380bb50cbb22f575ed742d58168cee37e99117a854bcd88f125";
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

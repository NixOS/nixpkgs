{ stdenv
, lib
, fetchPypi
, buildPythonPackage
, isPy3k
, python
}:

buildPythonPackage rec {
  pname = "docutils";
  version = "0.19";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-M5laZ1PDC39Xf+v8LFBBH+xqrH9//rfEz+WZEHLc+eY=";
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

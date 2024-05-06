{ stdenv
, lib
, fetchgit
, buildPythonPackage
, flit-core
, pillow
, python
, pythonOlder
}:

let self = buildPythonPackage rec {
  pname = "docutils";
  version = "0.21.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchgit {
    url = "git://repo.or.cz/docutils.git";
    rev = "docutils-${version}";
    hash = "sha256-ahnj6iKjyUCDxhgxJdwEb8huFIGpbuuLQBHDzKj6O9E=";
  };

  build-system = [ flit-core ];

  # infinite recursion via sphinx and pillow
  doCheck = false;
  passthru.tests.pytest = self.overridePythonAttrs { doCheck = true; };

  nativeCheckInputs = [
    pillow
  ];

  # Only Darwin needs LANG, but we could set it in general.
  # It's done here conditionally to prevent mass-rebuilds.
  checkPhase = lib.optionalString stdenv.isDarwin ''LANG="en_US.UTF-8" LC_ALL="en_US.UTF-8" '' + ''
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
};
in self

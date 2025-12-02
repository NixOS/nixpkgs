{
  lib,
  fetchurl,
  buildPythonPackage,
  flit-core,
  pillow,
  python,
  pythonOlder,
}:

# Note: this package is used to build LLVM’s documentation, which is part of the Darwin stdenv.
# It cannot use `fetchgit` because that would pull curl into the bootstrap, which is disallowed.

let
  self = buildPythonPackage rec {
    pname = "docutils";
    version = "0.21.2";
    pyproject = true;

    src = fetchurl {
      url = "mirror://sourceforge/docutils/docutils-${version}.tar.gz";
      hash = "sha256-OmsYcy7fGC2qPNEndbuzOM9WkUaPke7rEJ3v9uv6mG8=";
    };

    build-system = [ flit-core ];

    # infinite recursion via sphinx and pillow
    doCheck = false;
    passthru.tests.pytest = self.overridePythonAttrs { doCheck = true; };

    nativeCheckInputs = [ pillow ];

    checkPhase = ''
      runHook preCheck
      ${python.interpreter} test/alltests.py
      runHook postCheck
    '';

    # Create symlinks lacking a ".py" suffix, many programs depend on these names
    postFixup = ''
      for f in $out/bin/*.py; do
        ln -s $(basename $f) $out/bin/$(basename $f .py)
      done
    '';

    pythonImportsCheck = [ "docutils" ];

    meta = {
      description = "Python Documentation Utilities";
      homepage = "http://docutils.sourceforge.net/";
      changelog = "https://sourceforge.net/projects/docutils/files/docutils/${version}";
      license = with lib.licenses; [
        publicDomain
        bsd2
        psfl
        gpl3Plus
      ];
      maintainers = with lib.maintainers; [ jherland ];
      mainProgram = "docutils";
    };
  };
in
self

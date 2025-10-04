{
  lib,
  fetchPypi,
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

    disabled = pythonOlder "3.7";

    src = fetchPypi {
      inherit version pname;
      format = "setuptools";
      hash = "sha256-OmsYcy7fGC2qPNEndbuzOM9WkUaPke7rEJ3v9uv6mG8=";
    };

    build-system = [ flit-core ];

    # infinite recursion via sphinx and pillow
    doCheck = false;
    passthru.tests.pytest = self.overridePythonAttrs { doCheck = true; };

    nativeCheckInputs = [ pillow ];

    checkPhase = ''
      ${python.interpreter} test/alltests.py
    '';

    patches = [
      ./test_html5_polyglot_parts.patch # fix false positive failure
    ];

    # Create symlinks lacking a ".py" suffix, many programs depend on these names
    postFixup = ''
      for f in $out/bin/*.py; do
        ln -s $(basename $f) $out/bin/$(basename $f .py)
      done
    '';

    meta = with lib; {
      description = "Python Documentation Utilities";
      homepage = "http://docutils.sourceforge.net/";
      license = with licenses; [
        publicDomain
        bsd2
        psfl
        gpl3Plus
      ];
      maintainers = with maintainers; [ ];
    };
  };
in
self

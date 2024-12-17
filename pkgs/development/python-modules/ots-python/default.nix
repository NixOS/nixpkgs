{
  lib,
  buildPythonPackage,
  fetchPypi,
  substituteAll,
  opentype-sanitizer,
  setuptools-scm,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "ots-python";
  version = "9.1.0";
  format = "setuptools";

  src = fetchPypi {
    pname = "opentype-sanitizer";
    inherit version;
    hash = "sha256-1Zdd+eRECimZl8L8CCkm7pCjN0TafSsc5i2Y6/oH88I=";
  };

  patches = [
    # Invoke ots-sanitize from the opentype-sanitizer package instead of
    # downloading precompiled binaries from the internet.
    # (nixpkgs-specific, not upstreamable)
    (substituteAll {
      src = ./0001-use-packaged-ots.patch;
      ots_sanitize = "${opentype-sanitizer}/bin/ots-sanitize";
    })
  ];

  propagatedBuildInputs = [ opentype-sanitizer ];
  nativeBuildInputs = [ setuptools-scm ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Python wrapper for ots (OpenType Sanitizer)";
    homepage = "https://github.com/googlefonts/ots-python";
    license = licenses.bsd3;
    maintainers = with maintainers; [ danc86 ];
  };
}

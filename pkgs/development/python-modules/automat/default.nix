{ lib
, buildPythonPackage
, fetchPypi
, fetchpatch
, attrs
, pytest-benchmark
, pytestCheckHook
, setuptools-scm
, six
}:

let automat = buildPythonPackage rec {
  version = "20.2.0";
  pname = "automat";

  src = fetchPypi {
    pname = "Automat";
    inherit version;
    sha256 = "7979803c74610e11ef0c0d68a2942b152df52da55336e0c9d58daf1831cbdf33";
  };

  patches = [
    # don't depend on m2r
    (fetchpatch {
      name = "dont-depend-on-m2r.patch";
      url = "https://github.com/glyph/automat/compare/v20.2.0..2562fa4ddeba5b5945d9482baa4c26a414f5e831.patch";
      includes = [ "setup.py" ];
      hash = "sha256-jlPLJMu1QbBpiVYHDiqPydrXjEoZgYZTVVGNxSA0NxY=";
    })
  ];

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    six
    attrs
  ];

  checkInputs = [
    pytest-benchmark
    pytestCheckHook
  ];

  # escape infinite recursion with twisted
  doCheck = false;

  passthru.tests = {
    check = automat.overridePythonAttrs (_: { doCheck = true; });
  };

  meta = with lib; {
    homepage = "https://github.com/glyph/Automat";
    description = "Self-service finite-state machines for the programmer on the go";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}; in automat

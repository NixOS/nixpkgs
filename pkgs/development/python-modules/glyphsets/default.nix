{ lib
, buildPythonPackage
, fetchPypi
, defcon
, fonttools
, glyphslib
, pytestCheckHook
, setuptools
, setuptools-scm
, unicodedata2
}:

buildPythonPackage rec {
  pname = "glyphsets";
  version = "0.6.5";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Zp4VLJ9h6lkz7KOM7LWKAj7UX1KziLobzeT9Dosv5UU=";
  };

  patches = [
    # Upstream has a needlessly strict version range for setuptools_scm, our
    # setuptools-scm is newer. We can't use pythonRelaxDepsHook for this
    # because it's in setup_requires which means we'll fail the requirement
    # before pythonRelaxDepsHook can run.
    ./0001-relax-setuptools-scm-dep.patch
  ];

  propagatedBuildInputs = [
    defcon
    fonttools
    glyphslib
    setuptools
    unicodedata2
  ];
  nativeBuildInputs = [
    setuptools-scm
  ];

  doCheck = true;
  nativeCheckInputs = [
    pytestCheckHook
  ];
  preCheck = ''
    export PATH="$out/bin:$PATH"
  '';

  meta = with lib; {
    description = "Google Fonts glyph set metadata";
    homepage = "https://github.com/googlefonts/glyphsets";
    license = licenses.asl20;
    maintainers = with maintainers; [ danc86 ];
  };
}

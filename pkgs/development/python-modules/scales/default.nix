{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  fetchpatch2,
  six,
}:

buildPythonPackage rec {
  pname = "scales";
  version = "1.0.9";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8b6930f7d4bf115192290b44c757af5e254e3fcfcb75ff9a51f5c96a404e2753";
  };

  patches = [
    # Use html module in Python 3 and cgi module in Python 2
    # https://github.com/Cue/scales/pull/47
    (fetchpatch2 {
      url = "https://github.com/Cue/scales/commit/ee69d45f1a7f928f7b241702e9be06007444115e.patch?full_index=1";
      hash = "sha256-xBlgkh1mf+3J7GtNI0zGb7Sum8UYbTpUmM12sxK/fSU=";
    })
  ];

  postPatch = ''
    for file in scales_test formats_test aggregation_test; do
      substituteInPlace src/greplin/scales/$file.py \
        --replace-fail "assertEquals" "assertEqual"
    done;
  '';

  nativeCheckInputs = [ pytestCheckHook ];
  propagatedBuildInputs = [ six ];

  meta = with lib; {
    description = "Stats for Python processes";
    homepage = "https://www.github.com/Cue/scales";
    license = licenses.asl20;
  };
}

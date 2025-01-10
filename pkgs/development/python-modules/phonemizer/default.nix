{
  lib,
  stdenv,
  substituteAll,
  buildPythonPackage,
  fetchPypi,
  joblib,
  segments,
  attrs,
  dlinfo,
  typing-extensions,
  espeak-ng,
  setuptools,
  pytest,
}:

buildPythonPackage rec {
  pname = "phonemizer";
  version = "3.3.0";
  pyproject = true;

  build-system = [ setuptools ];

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Xgw4Ei7/4LMxok5nSv8laHTs4WnXCpzxEgM3tW+OPQw=";
  };

  patches = [
    (substituteAll {
      src = ./backend-paths.patch;
      libespeak = "${lib.getLib espeak-ng}/lib/libespeak-ng${stdenv.hostPlatform.extensions.sharedLibrary}";
      # FIXME package festival
    })
  ];

  propagatedBuildInputs = [
    joblib
    segments
    attrs
    dlinfo
    typing-extensions
  ];

  # We tried to package festival, but were unable to get the backend running,
  # so let's disable related tests.
  doCheck = false;

  meta = {
    homepage = "https://github.com/bootphon/phonemizer";
    changelog = "https://github.com/bootphon/phonemizer/blob/v${version}/CHANGELOG.md";
    description = "Simple text to phones converter for multiple languages";
    mainProgram = "phonemize";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ bot-wxt1221 ];
  };
}

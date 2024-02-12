{ lib
, stdenv
, substituteAll
, buildPythonPackage
, fetchPypi
, joblib
, segments
, attrs
, dlinfo
, typing-extensions
, espeak-ng
, pytestCheckHook
, pytest-cov
}:

buildPythonPackage rec {
  pname = "phonemizer";
  version = "3.2.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Bo+F+FqKmtxjijeHrqyvcaU+R1eLEtdzwJdDNQDNiSs=";
  };

  postPatch = ''
    sed -i '/pytest-runner/d' setup.py
  '';

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

  meta = with lib; {
    homepage = "https://github.com/bootphon/phonemizer";
    changelog = "https://github.com/bootphon/phonemizer/blob/v${version}/CHANGELOG.md";
    description = "Simple text to phones converter for multiple languages";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ ];
  };
}

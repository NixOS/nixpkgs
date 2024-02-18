{ lib
, buildPythonPackage
, click
, fetchPypi
, python
}:

buildPythonPackage rec {
  pname = "confusable_homoglyphs";
  version = "3.3.1";
  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-uZUAHJsuG0zqDPXzhAp8eRiKjLutBT1pNXK9jBwexGA=";
  };

  nativeCheckInputs = [
    click
  ];

  pythonImportsCheck = [
    "confusable_homoglyphs"
  ];

  checkPhase = ''
    runHook preCheck

    ftp_proxy=http://invalid.org ${python.pythonOnBuildForHost.interpreter} -m unittest tests/*.py

    runHook postCheck
  '';

  meta = with lib; {
    description = "A homoglyph is one of two or more graphemes, characters, or glyphs with shapes that appear identical or very similar.";
    homepage = "https://sr.ht/~valhalla/confusable_homoglyphs/";
    license = licenses.mit;
    maintainers = with maintainers; [ rogryza ];
  };
}

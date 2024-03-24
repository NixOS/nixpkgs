{ lib
, buildPythonPackage
, click
, fetchPypi
}:

buildPythonPackage rec {
  pname = "confusable_homoglyphs";
  version = "3.2.0";
  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-O0oNn6UQZpSYggyRoL/AwydWjOzskGSM84GdSm/Gp1E=";
  };

  nativeCheckInputs = [
    click
  ];

  pythonImportsCheck = [
    "confusable_homoglyphs"
  ];

  meta = with lib; {
    description = "A homoglyph is one of two or more graphemes, characters, or glyphs with shapes that appear identical or very similar.";
    homepage = "https://sr.ht/~valhalla/confusable_homoglyphs/";
    license = licenses.mit;
    maintainers = with maintainers; [ rogryza ];
  };
}

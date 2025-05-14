{
  lib,
  buildPythonPackage,
  fetchPypi,
  six,
  random2,
}:

buildPythonPackage rec {
  pname = "pysol-cards";
  version = "0.22.0";
  format = "setuptools";

  src = fetchPypi {
    inherit version;
    pname = "pysol_cards";
    hash = "sha256-xVXvXgWtQXdOdCtgPObmunbl0BPd9K4Iej2HxVJ58UI=";
  };

  propagatedBuildInputs = [
    six
    random2
  ];

  meta = with lib; {
    description = "Generates Solitaire deals";
    mainProgram = "pysol_cards";
    homepage = "https://github.com/shlomif/pysol_cards";
    license = licenses.mit;
    maintainers = with maintainers; [ mwolfe ];
  };
}

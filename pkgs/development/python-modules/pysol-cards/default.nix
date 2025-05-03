{
  lib,
  buildPythonPackage,
  fetchPypi,
  six,
  random2,
}:

buildPythonPackage rec {
  pname = "pysol-cards";
  version = "0.20.0";
  format = "setuptools";

  src = fetchPypi {
    inherit version;
    pname = "pysol_cards";
    hash = "sha256-0jlmFojJyvvTA+Hv0PEUjZByHja5lC+mFVOtUgoVa0E=";
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

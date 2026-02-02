{
  lib,
  buildPythonPackage,
  setuptools,
  afdko,
  cffsubr,
  defcon,
  dehinter,
  fonttools,
  ttfautohint-py,
  ufo2ft,
  ufolib2,
  fetchPypi,
  ufo-extractor,
}:
buildPythonPackage rec {
  pname = "foundrytools";
  version = "0.1.4"; # NEWER AVAILABLE: 0.1.5
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-pWHSIhj0g1jUs6ij5o2NGcDBrgJDBCXjQyJmSpYOxfo=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    afdko
    cffsubr
    defcon
    dehinter
    fonttools
    ttfautohint-py
    ufo-extractor
    ufo2ft
    ufolib2
  ];

  meta = {
    description = "A library for working with fonts in Python.";
    homepage = "https://github.com/ftCLI/FoundryTools";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      qb114514
    ];
  };
}

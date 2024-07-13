{
  lib,
  buildPythonPackage,
  fetchPypi,
  random2,
  setuptools,
  six,
}:

let
  self = buildPythonPackage {
    pname = "pysol-cards";
    version = "0.16.0";
    pyproject = true;

    src = fetchPypi {
      pname = "pysol_cards";
      inherit (self) version;
      hash = "sha256-C4fKez+ZFVzM08/XOfc593RNb4GYIixtSToDSj1FcMM=";
    };

    build-system = [ setuptools ];

    dependencies = [
      random2
      six
    ];

    meta = {
      homepage = "https://github.com/shlomif/pysol_cards";
      description = "Generates Solitaire deals";
      longDescription = ''
        The pysol-cards python modules allow the python developer to generate
        the initial deals of some PySol FC games. It also supports PySol legacy
        deals and Microsoft FreeCell / Freecell Pro deals.
      '';
      license = lib.licenses.mit;
      mainProgram = "pysol_cards";
      maintainers = with lib.maintainers; [ mwolfe AndersonTorres ];
    };
  };
in
self

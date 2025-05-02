{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pythonOlder
, nix-update-script
, hatch-vcs
, hatchling
, brotli
, fonttools
}:

buildPythonPackage rec {
  pname = "bdffont";
  version = "0.0.20";

  disabled = pythonOlder "3.11";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-T0gTtudsZmL0VZ3a3+C/v+dWAwbXUgf0PEdNtkxWROw=";
  };

  format = "pyproject";

  nativeBuildInputs = [
    hatch-vcs
    hatchling
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/TakWolf/bdffont";
    description = "A library for manipulating .bdf format fonts";
    platforms = lib.platforms.all;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ h7x4 ];
  };
}

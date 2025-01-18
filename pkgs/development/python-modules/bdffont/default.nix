{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  pytestCheckHook,
  nix-update-script,
  hatchling,
}:

buildPythonPackage rec {
  pname = "bdffont";
  version = "0.0.26";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchPypi {
    pname = "bdffont";
    inherit version;
    hash = "sha256-Q8IqwJmAYFicTX7RrVU9UvGZX+oaPb0RKlIFwArktXk=";
  };

  build-system = [ hatchling ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "bdffont" ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    homepage = "https://github.com/TakWolf/bdffont";
    description = "A library for manipulating Glyph Bitmap Distribution Format (BDF) Fonts";
    platforms = platforms.all;
    license = licenses.mit;
    maintainers = with maintainers; [
      TakWolf
      h7x4
    ];
  };
}

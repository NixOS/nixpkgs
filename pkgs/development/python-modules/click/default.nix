{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, fetchpatch
, importlib-metadata
, pytestCheckHook

# large-rebuild downstream dependencies and applications
, flask
, black
, magic-wormhole
, mitmproxy
, typer
}:

buildPythonPackage rec {
  pname = "click";
  version = "8.1.3";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-doLcivswKXABZ0V16gDRgU2AjWo2r0Fagr1IHTe6e44=";
  };

  patches = [
    (fetchpatch {
      # pytest 7.3.0 compat
      name = "click-pytest-7.3.0-compat.patch";
      url = "https://github.com/pallets/click/commit/0f5fbb7e4d893945b4c07cfe4f81cd82fb2900ed.patch";
      hash = "sha256-Xgkrn81K9Qzz1T3lfGHCm6rIl/omG+DhmCa6jj7cauw=";
    })
  ];

  propagatedBuildInputs = lib.optionals (pythonOlder "3.8") [
    importlib-metadata
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  passthru.tests = {
    inherit black flask magic-wormhole mitmproxy typer;
  };

  meta = with lib; {
    homepage = "https://click.palletsprojects.com/";
    description = "Create beautiful command line interfaces in Python";
    longDescription = ''
      A Python package for creating beautiful command line interfaces in a
      composable way, with as little code as necessary.
    '';
    license = licenses.bsd3;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}

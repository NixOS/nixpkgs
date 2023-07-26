{ lib
, buildPythonPackage
, fetchpatch
, fetchPypi
, pythonOlder
, setuptools
, wheel
}:

buildPythonPackage rec {
  pname = "insteon-frontend-home-assistant";
  version = "0.3.5-1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-R+P4pgKbLvf0mwpSDoujCvlJe/yS+nvSJ7ewLVOOg/0=";
  };

  patches = [
    # https://github.com/pyinsteon/insteon-panel/pull/33
    (fetchpatch {
      name = "unpin-setuptools.patch";
      url = "https://github.com/pyinsteon/insteon-panel/commit/2297eb05668907edd03633f244e5876990e340c7.patch";
      hash = "sha256-kTu1+IwDrcdqelyK/vfhxw8MQBis5I1jag7YTytKQhs=";
    })
  ];

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  # upstream has no tests
  doCheck = false;

  pythonImportsCheck = [
    "insteon_frontend"
  ];

  meta = with lib; {
    changelog = "https://github.com/pyinsteon/insteon-panel/releases/tag/${version}";
    description = "The Insteon frontend for Home Assistant";
    homepage = "https://github.com/pyinsteon/insteon-panel";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}

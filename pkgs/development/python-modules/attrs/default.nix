{
  lib,
  callPackage,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  hatchling,
}:

buildPythonPackage rec {
  pname = "attrs";
  version = "23.2.0";
  disabled = pythonOlder "3.7";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-k13DtSnCYvbPduUId9NaS9PB3hlP1B9HoreujxmXHzA=";
  };

  patches = [
    # hatch-vcs and hatch-fancy-pypi-readme depend on pytest, which depends on attrs
    ./remove-hatch-plugins.patch
  ];

  postPatch = ''
    substituteAllInPlace pyproject.toml
  '';

  nativeBuildInputs = [ hatchling ];

  outputs = [
    "out"
    "testout"
  ];

  postInstall = ''
    # Install tests as the tests output.
    mkdir $testout
    cp -R conftest.py tests $testout
  '';

  pythonImportsCheck = [ "attr" ];

  # pytest depends on attrs, so we can't do this out-of-the-box.
  # Instead, we do this as a passthru.tests test.
  doCheck = false;

  passthru.tests = {
    pytest = callPackage ./tests.nix { };
  };

  meta = with lib; {
    description = "Python attributes without boilerplate";
    homepage = "https://github.com/python-attrs/attrs";
    changelog = "https://github.com/python-attrs/attrs/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}

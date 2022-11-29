{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, click
, setuptools-scm
, pythonOlder
}:

buildPythonPackage rec {
  pname = "cloup";
  version = "1.0.1";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-iQfpz2rl7Y3PJIG2aO+Cu1khx2g68XfOwhkRoENqsTg=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    click
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "cloup" ];

  meta = with lib; {
    homepage = "https://github.com/janLuke/cloup";
    description = "Click extended with option groups, constraints, aliases, help themes";
    longDescription = ''
      Enriches Click with option groups, constraints, command aliases, help sections for subcommands, themes for --help and other stuff.
    '';
    license = licenses.bsd3;
    maintainers = with maintainers; [ friedelino ];
  };
}

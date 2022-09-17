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
  version = "1.0.0";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-/DR3evRK1d7Kz9dCp4RzeAD5opsYPZF0ox0HqR9u710=";
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

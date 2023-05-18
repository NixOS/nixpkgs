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
  version = "2.1.0";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-3ULHyc1JP63FOkI2+WF4o/EYu72UWn+K2vzVA02CaXE=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    click
  ];

  nativeCheckInputs = [
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

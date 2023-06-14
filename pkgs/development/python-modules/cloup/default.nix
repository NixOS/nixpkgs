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
  version = "2.1.1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-u/4RaGM0MJs/vodq99ubwmXU6uqTtWL9E0cnZ69khhU=";
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

  pythonImportsCheck = [
    "cloup"
  ];

  meta = with lib; {
    homepage = "https://github.com/janLuke/cloup";
    description = "Click extended with option groups, constraints, aliases, help themes";
    changelog = "https://github.com/janluke/cloup/releases/tag/v${version}";
    longDescription = ''
      Enriches Click with option groups, constraints, command aliases, help sections for subcommands, themes for --help and other stuff.
    '';
    license = licenses.bsd3;
    maintainers = with maintainers; [ friedelino ];
  };
}

{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  attrs,
  pexpect,
  pyyaml,
  requests,
  termcolor,
  jellyfish,
  cryptography,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "lib50";
  version = "3.0.12";
  pyproject = true;

  # latest GitHub release is several years old. Pypi is up to date.
  src = fetchPypi {
    pname = "lib50";
    inherit version;
    hash = "sha256-Fc4Hb1AbSeetK3gH1/dRCUfHGDlMzfzgF1cnK3Se01U=";
  };

  build-system = [ setuptools ];

  dependencies = [
    attrs
    pexpect
    pyyaml
    requests
    termcolor
    jellyfish
    cryptography
  ];

  pythonRelaxDeps = [
    "attrs"
    "pyyaml"
    "termcolor"
    "jellyfish"
  ];

  pythonImportsCheck = [ "lib50" ];

  # latest GitHub release is several years old and doesn't include
  # tests and neither does pypi version include tests
  doCheck = false;

  meta = {
    description = "CS50's own internal library used in many of its tools";
    homepage = "https://github.com/cs50/lib50";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ ethancedwards8 ];
  };
}

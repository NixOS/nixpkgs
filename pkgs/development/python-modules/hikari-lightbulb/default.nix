{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  wheel,
  hikari,
  croniter,
}:

buildPythonPackage rec {
  pname = "hikari-lightbulb";
  version = "2.3.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tandemdude";
    repo = "hikari-lightbulb";
    rev = version;
    hash = "sha256-gqbbex2xj48LZqW4bVSPDW1UZEFVeOHbNQVM6nhpl1Y=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [ hikari ];

  passthru.optional-dependencies = {
    crontrigger = [ croniter ];
  };

  pythonImportsCheck = [ "lightbulb" ];

  meta = with lib; {
    description = "Command handler for Hikari, the Python Discord API wrapper library";
    longDescription = ''
      Lightbulb is designed to be an easy to use command handler library that integrates with the Discord API wrapper library for Python, Hikari.

      This library aims to make it simple for you to make your own Discord bots and provide all the utilities and functions you need to help make this job easier.
    '';
    homepage = "https://hikari-lightbulb.readthedocs.io/en/latest/";
    # https://github.com/tandemdude/hikari-lightbulb/blob/d87df463488d1c1d947144ac0bafa4304e12ddfd/setup.py#L68
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ tomodachi94 ];
  };
}

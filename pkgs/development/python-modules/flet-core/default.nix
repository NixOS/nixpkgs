{ lib
, buildPythonPackage
, fetchPypi

# build-system
, poetry-core

# propagates
, typing-extensions
, repath
}:

buildPythonPackage rec {
  pname = "flet-core";
  version = "0.20.1";
  pyproject = true;

  src = fetchPypi {
    pname = "flet_core";
    inherit version;
    hash = "sha256-W5HhqsC/YpgL1sorPLV+ty/G09Y2gMe08n4qsrNi8gA=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    repath
    typing-extensions
  ];

  doCheck = false;

  meta = {
    changelog = "https://github.com/flet-dev/flet/releases/tag/v${version}";
    description = "The library is the foundation of Flet framework and is not intended to be used directly";
    homepage = "https://flet.dev/";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.heyimnova ];
  };
}

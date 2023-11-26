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
  version = "0.10.1";
  format = "pyproject";

  src = fetchPypi {
    pname = "flet_core";
    inherit version;
    hash = "sha256-YLtHnKBlXkUJJkQzxnDkfl6+gSGm05GXYPGEU3XO/jI=";
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
    description = "The library is the foundation of Flet framework and is not intended to be used directly";
    homepage = "https://flet.dev/";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.heyimnova ];
  };
}

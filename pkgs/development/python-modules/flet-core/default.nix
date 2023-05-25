{ lib
, python3
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "flet-core";
  version = "0.6.2";
  format = "pyproject";

  src = fetchPypi {
    pname = "flet_core";
    inherit version;
    hash = "sha256-WMkm+47xhuYz1HsiPfF7YbOCg7Xlbj9oHI9nVtwAb/w=";
  };

  nativeBuildInputs = with python3.pkgs; [
    poetry-core
  ];

  propagatedBuildInputs = with python3.pkgs; [
    typing-extensions
    repath
  ];

  doCheck = false;

  meta = {
    description = "The library is the foundation of Flet framework and is not intended to be used directly";
    homepage = "https://flet.dev/";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.heyimnova ];
  };
}

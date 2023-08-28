{ lib
, buildPythonPackage

# build-system
, poetry-core
, pytestCheckHook

# propagates
, typing-extensions
, repath

, flet-client-flutter
}:

buildPythonPackage rec {
  pname = "flet-core";
  version = "0.7.4";
  format = "pyproject";

  inherit (flet-client-flutter) src;
  sourceRoot = "source/sdk/python/packages/flet-core";

  nativeBuildInputs = [
    poetry-core
    pytestCheckHook
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
    maintainers = with lib.maintainers; [ heyimnova  lucasew ];
  };
}

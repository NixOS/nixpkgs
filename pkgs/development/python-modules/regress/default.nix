{ lib
, fetchPypi
, buildPythonPackage
, rustPlatform
}:

buildPythonPackage rec {
  pname = "regress";
  version = "0.4.2";

  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-d+pRVDBe2GPg32sw4w92SO4OXGgIWomJ5+1j/Yw6wEg=";
  };

  nativeBuildInputs = with rustPlatform; [ cargoSetupHook maturinBuildHook ];

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-9euFjFCRsXmOxG2BApUl3LJYqadWMTw6uU4S35HDcXw=";
  };

  meta = with lib; {
    description = "Python bindings to the Rust regress crate, exposing ECMA regular expressions.";
    homepage = "https://github.com/Julian/regress";
    license = licenses.mit;
    maintainers = [ maintainers.matthiasbeyer ];
  };
}

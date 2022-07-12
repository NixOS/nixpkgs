{ lib
, fetchPypi
, buildPythonPackage
, rustPlatform }:

buildPythonPackage rec {
  pname = "py-sr25519-bindings";
  version = "0.1.4";
  format = "pyproject";

  src = fetchPypi {
    inherit version;
    pname = "py_sr25519_bindings";
    sha256 = "sha256-XhLKl3AU8Uj0v7a6Zi8VKbFcyM4DBxnXJsThajeel24=";
  };

  patches = [ ./cargo.lock.patch ];
  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-B94Ax7ElP5pshuqyuAnJetvnKiVpfIAIvm8dUP5ObxE=";
    patches = [ ./cargo.lock.patch ];
  };

  nativeBuildInputs = [
  ] ++ (with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ]);


  meta = with lib; {
    description = "Python bindings for sr25519 library";
    homepage = "https://github.com/polkascan/py-sr25519-bindings";
    license = licenses.asl20;
    maintainers = with maintainers; [ onny ];
  };
}

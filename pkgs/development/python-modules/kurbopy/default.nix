{ lib
, buildPythonPackage
, fetchPypi
, fonttools
, pytestCheckHook
, python
, rustPlatform
, unzip
}:

buildPythonPackage rec {
  pname = "kurbopy";
  version = "0.10.40";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-dhpcDi20Na6SDbRxrC8N3SWdN1J/CWJgCUI3scJX/6s=";
  };

  propagatedBuildInputs = [
    fonttools
  ];
  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-V3LeT0dqkfft1ftc+azwvuSzzdUJ7/wAp31fN7te9RQ=";
  };

  doCheck = true;
  nativeCheckInputs = [
    pytestCheckHook
  ];
  preCheck = ''
    # pytestCheckHook puts . at the front of Python's sys.path, due to:
    # https://github.com/NixOS/nixpkgs/issues/255262
    # So we need to prevent pytest from trying to import kurbopy from
    # ./kurbopy, which contains the sources but not the newly built module.
    # We want it to import kurbopy from the nix store via $PYTHONPATH instead.
    rm -r kurbopy
  '';

  meta = with lib; {
    description = "Python wrapper around the Rust kurbo library for 2D curve manipulation";
    homepage = "https://github.com/simoncozens/kurbopy";
    license = licenses.asl20;
    maintainers = with maintainers; [ danc86 ];
  };
}

{
  lib,
  buildPythonPackage,
  fetchPypi,
  fonttools,
  pytestCheckHook,
  rustPlatform,
}:

buildPythonPackage rec {
  pname = "kurbopy";
  version = "0.11.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-0TIVx0YH5L8l6at1fcWkj2UZYK0aF1fahTu9/+7MWMI=";
  };

  propagatedBuildInputs = [ fonttools ];
  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-W0BebCXC1wqwtQP+zHjISxSJjXHD9U6p9eNS12Nfb2Y=";
  };

  doCheck = true;
  nativeCheckInputs = [ pytestCheckHook ];
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

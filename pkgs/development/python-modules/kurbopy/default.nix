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
  version = "0.11.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-05ezUpcHxCxo/4oyPKogq4/vdfpNnEBhtv+lYBjKdvg=";
  };

  propagatedBuildInputs = [ fonttools ];
  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-51qJAcJvolYCW3XWeymc2xd2QHiKLd7MdRdDedEH8QY=";
  };

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

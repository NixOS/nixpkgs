{
  lib,
  buildPythonPackage,
  fetchPypi,
  matplotlib,
  pandas,
  python,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "quantconnect-stubs";
  version = "18228";
  pyproject = true;

  src = fetchPypi {
    pname = "quantconnect_stubs";
    inherit (finalAttrs) version;
    hash = "sha256-porOS6ff7FyncTiJ7QXFb6w84vDqKq+zgRdFR+psNq4=";
  };

  build-system = [ setuptools ];

  dependencies = [
    matplotlib
    pandas
  ];

  # The stubs are `.pyi` files and the `__init__.py` modules are only importable
  # with pythonnet, so check that they were installed instead of importing them.
  postInstallCheck = ''
    test -f $out/${python.sitePackages}/AlgorithmImports/__init__.pyi
    test -f $out/${python.sitePackages}/QuantConnect/Algorithm/__init__.pyi
  '';

  meta = {
    description = "Type stubs for QuantConnect's LEAN engine";
    homepage = "https://github.com/QuantConnect/quantconnect-stubs-generator";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nimakalantar ];
  };
})

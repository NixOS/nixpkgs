{
  buildPythonPackage,
  python,
  root,
}:

let
  unwrapped = root.override { python3 = python; };
in
buildPythonPackage {
  # ROOT builds the C++ libraries and CPython extensions in one package and
  # python versions must never be mixed
  passthru = {
    inherit unwrapped;
  };

  inherit (unwrapped) pname version meta;

  src = null;

  format = "other"; # disables setuptools/pyproject logic

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    mkdir -p $out/${python.sitePackages}
    rmdir $out/${python.sitePackages}
    ln -s ${unwrapped}/lib $out/${python.sitePackages}
  '';

  # Those namespaces are looked up dynamically via ROOTs CPython extension, so
  # these checks cover the most fragile parts of the package
  pythonImportsCheck = [
    "ROOT"
    "ROOT.Experimental"
    "ROOT.Math"
    "ROOT.RooFit"
    "ROOT.std"
  ];
}

{
  buildPythonPackage,
  python,
  pkgs,
}:

buildPythonPackage rec {
  # ROOT builds the C++ libraries and CPython extensions in one package. We
  # therefore need to override the root package to build against the requested
  # Python version.
  unwrapped = pkgs.root.override { python3 = python; };

  # Properties like pname, version, and meta are taken from the main ROOT package
  pname = unwrapped.name;
  version = unwrapped.version;

  src = null;

  format = "other"; # disables setuptools/pyproject logic

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  # Create only the parent directory of python.sitePackages, such that we can
  # create the sitePackages directory as a symlink to the ROOT library
  # directory.
  installPhase = ''
    mkdir -p $out/${python.sitePackages}
    rmdir $out/${python.sitePackages}
    ln -s ${unwrapped}/lib $out/${python.sitePackages}
  '';

  # We can conveniently check if everything works by trying to import some C++
  # namespaces via ROOT. Since these are looked up dynamically in the libraries
  # via ROOTs CPython extension, these checks already cover the fragile parts
  # of the ROOT python module.
  pythonImportsCheck = [
    "ROOT"
    "ROOT.Experimental"
    "ROOT.Math"
    "ROOT.RooFit"
  ];

  meta = unwrapped.meta;
}

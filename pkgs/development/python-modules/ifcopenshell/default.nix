{
  callPackage,
  lib,
  stdenv,
  testers,
  buildPythonPackage,
  python,
  pytestCheckHook,
  # fetchers
  fetchFromGitHub,
  gitUpdater,
  # native dependencies
  ifcopenshell,

  # python deps
  ## tools
  setuptools,
  setuptools-scm,
  build,
  pytest,
  ## dependencies
  isodate,
  lark,
  numpy,
  python-dateutil,
  shapely,
  typing-extensions,
  ## additional deps for tests
  toposort,
  requests,
  lxml,
  networkx,
  tabulate,
  xmlschema,
  xsdata,
}:
let
  # ifcopenshell-python build againts a specific native commit, which is *not*
  # the same as the ifcconvert release. see
  # https://github.com/IfcOpenShell/IfcOpenShell/blob/ifcopenshell-python-0.8.5/src/ifcopenshell-python/Makefile#L58
  # NOTE: exceptionnally we don't use the commit mentioned in this makefile,
  # because it simply doesn't compile currently 🤷
  ifcopenshellNative =
    (ifcopenshell.overrideAttrs {
      src = fetchFromGitHub {
        owner = "IfcOpenShell";
        repo = "IfcOpenShell";
        tag = "ifcopenshell-python-0.8.5";
        fetchSubmodules = true;
        hash = "sha256-QL+b46tOqoaN8XhxM02B2LWeAdu4OhhbCCVe7bMohBI=";
      };
    }).override
      {
        python3 = python;
        withPython = true;
      };
in
buildPythonPackage (finalAttrs: {
  pname = "ifcopenshell";
  version = "0.8.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "IfcOpenShell";
    repo = "IfcOpenShell";
    tag = "ifcopenshell-python-${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-QL+b46tOqoaN8XhxM02B2LWeAdu4OhhbCCVe7bMohBI=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  build-system = [
    setuptools
    setuptools-scm
  ];

  # copy the native part
  preConfigure = ''
    cd src/ifcopenshell-python
    cp -v ${lib.getLib ifcopenshellNative}/${python.sitePackages}/ifcwrap/ifcopenshell_wrapper.py ./ifcopenshell
    cp ${lib.getLib ifcopenshellNative}/${python.sitePackages}/ifcwrap/_ifcopenshell_wrapper.cpython-${
      lib.versions.major python.version + lib.versions.minor python.version
    }-${stdenv.targetPlatform.system}-gnu.so ./ifcopenshell
  '';

  propagatedBuildInputs = [
    isodate
    lark
    numpy
    python-dateutil
    shapely
    typing-extensions
  ];

  pythonImportsCheck = [ "ifcopenshell" ];

  env.PYTHONUSERBASE = ".";

  postPatch = ''
    pushd src/ifcopenshell-python
    # The build process is here: https://github.com/IfcOpenShell/IfcOpenShell/blob/ifcopenshell-python-0.8.5/src/ifcopenshell-python/Makefile#L126
    # NOTE: it has changed a *lot* between 0.7.0 and 0.8.0, it *may* change again
    substituteInPlace pyproject.toml --replace-fail "0.0.0" "${finalAttrs.version}"
    # NOTE: the following is directly inspired by https://github.com/IfcOpenShell/IfcOpenShell/blob/ifcopenshell-python-0.8.5/src/ifcopenshell-python/Makefile#L143
    cp ../../README.md README.md
    popd
  '';

  # NOTE: activating tests is difficult:
  # - tests depends on some python packages that are not packaged
  # - they are inside ifcopenshell source tree (look for bcf, ifcpatch, ...)
  # - at least bcf itself depends on ifcopenshell itself

  passthru = {
    updateScript = gitUpdater { rev-prefix = "ifcopenshell-python-"; };
  };

  meta = {
    broken = stdenv.hostPlatform.isDarwin;
    description = "Open source IFC library and geometry engine";
    homepage = "https://ifcopenshell.org/";
    license = lib.licenses.lgpl3;
    teams = [ lib.teams.geospatial ];
  };
})

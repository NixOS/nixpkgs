{
  lib,
  buildPythonPackage,
  fetchPypi,
  python,

  # build-system
  dash,
  hatchling,
  hatch-jupyter-builder,
  pyyaml,
  setuptools,

  # nativeBuildInputs
  nodejs,

  # dependencies
  ipython,
  numpy,
  pandas,
}:

buildPythonPackage rec {
  pname = "itables";
  version = "2.4.3";

  # itables has 4 different node packages, each with their own
  # package-lock.json, and partially depending on each other.
  # Our fetchNpmDeps tooling in nixpkgs doesn't support this yet, so we fetch
  # the source tarball from pypi, which includes the javascript bundle already.
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-lv+GdI6jHszdbsPG09QDGMaFGp5GD1/SPdrgsvhlqfU=";
  };

  pyproject = true;

  build-system = [
    dash
    hatchling
    hatch-jupyter-builder
    pyyaml
    setuptools
  ];

  nativeBuildInputs = [
    nodejs
  ];

  dependencies = [
    ipython
    numpy
    pandas
  ];

  # no tests in pypi tarball
  doCheck = false;

  # don't run the hooks, as they try to invoke npm on packages/,
  env.HATCH_BUILD_NO_HOOKS = true;

  # The pyproject.toml shipped with the sources doesn't install anything,
  # as the paths in the pypi tarball are not the same as in the repo checkout.
  # We exclude itables_for_dash here, as it's missing the .dist-info dir
  # plumbing to be discoverable, and should be its own package anyways.
  postInstall = ''
    cp -R itables $out/${python.sitePackages}
  '';

  pythonImportsCheck = [ "itables" ];

  meta = {
    description = "Pandas and Polar DataFrames as interactive DataTables";
    homepage = "https://github.com/mwouts/itables";
    changelog = "https://github.com/mwouts/itables/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ flokli ];
  };
}

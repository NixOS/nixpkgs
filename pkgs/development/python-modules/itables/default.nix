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

<<<<<<< HEAD
  # optional-dependencies
  ipython,
  numpy,
  pandas,
  polars,
  narwhals,
  matplotlib,
  anywidget,
  traitlets,
  streamlit,
  marimo,
  pyarrow,
  typing-extensions,
=======
  # dependencies
  ipython,
  numpy,
  pandas,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

buildPythonPackage rec {
  pname = "itables";
<<<<<<< HEAD
  version = "2.6.2";
=======
  version = "2.5.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  # itables has 4 different node packages, each with their own
  # package-lock.json, and partially depending on each other.
  # Our fetchNpmDeps tooling in nixpkgs doesn't support this yet, so we fetch
  # the source tarball from pypi, which includes the javascript bundle already.
  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-P3PzBBB022Q3+9L3Loq18kyWhXB2JcCF/3FwHUPkxi8=";
=======
    hash = "sha256-7DS7rPv0MFVw6nWzaXDeRC+SQSbzcBwyOlpGAY3oTIo=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  # shiny and modin omitted due to missing deps
  optional-dependencies = {
    all = [
      pandas
      polars
      narwhals
      matplotlib
      ipython
      anywidget
      traitlets
      dash
      streamlit
      marimo
      pyarrow
    ];
    pandas = [ pandas ];
    polars = [ polars ];
    narwhals = [ narwhals ];
    style = [
      pandas
      matplotlib
    ];
    notebook = [ ipython ];
    widget = [
      anywidget
      traitlets
    ];
    dash = [
      dash
      typing-extensions
    ];
    streamlit = [ streamlit ];
    marimo = [ marimo ];
    other_dataframes = [
      narwhals
      pyarrow
    ];
  };
=======
  dependencies = [
    ipython
    numpy
    pandas
  ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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

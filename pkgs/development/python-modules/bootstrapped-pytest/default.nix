# A pytest(-xdist) package that does not depend on any other python packages
# Can be used to test all other packages without causing infinite recursion

{ bootstrapped-pip
, fetchPypi
, isPy27
, lib
, makeWrapper
, python
, stdenv
, unzip

# python packages to take sources from
, apipkg
, attrs
, execnet
, iniconfig
, packaging
, pluggy
, py
, pyparsing
, pytest
, pytest-forked
, pytest-xdist
, setuptools-scm
, setuptools
, toml
, python2Packages
, breakpointHook
}:

let

  # the order is relevant for renaming unpacked archives
  allDeps = [
    apipkg
    attrs
    execnet
    iniconfig
    packaging
    pluggy
    py
    pyparsing
    pytest
    pytest-forked
    pytest-xdist
    setuptools-scm
    setuptools
    toml
  ] ++ (lib.optionals isPy27 ( with python2Packages; [
    atomicwrites
    configparser
    contextlib2
    funcsigs
    importlib-metadata
    more-itertools
    pathlib2
    scandir
    six
    zipp
  ]));

  extraPnames = lib.optionals isPy27 [
    "atomicwrites"
    "configparser"
    "contextlib2"
    "funcsigs"
    "importlib_metadata"
    "more-itertools"
    "pathlib2"
    "scandir"
    "six"
    "zipp"
  ];

in

stdenv.mkDerivation rec {

  pname = "pytest";

  inherit (pytest) version;

  name = "${python.libPrefix}-bootstrapped-${pname}-${version}";

  srcs = lib.forEach allDeps (dep: dep.src);

  allDepNames = lib.forEach allDeps (dep: dep.pname);

  sourceRoot = ".";

  format = "other";

  doCheck = true;

  postPatch = ''
    mkdir -p $out/bin
  '';

  nativeBuildInputs = [ bootstrapped-pip makeWrapper unzip  breakpointHook];

  buildInputs = [ python ];

  dontInstall = true;

  buildPhase = lib.strings.optionalString (!stdenv.hostPlatform.isWindows) ''
    export SETUPTOOLS_INSTALL_WINDOWS_SPECIFIC_FILES=0

    # Give folders a known name
    mkdir renamed
    mv source renamed/pyparsing
    mv setuptools-* renamed/setuptools
    mv setuptools_scm* renamed/setuptools_scm
    for dep in apipkg attrs execnet iniconfig packaging pluggy toml pytest-xdist pytest-forked pytest py ${toString extraPnames}; do
      echo "moving $dep"
      mv $dep* renamed/$dep
    done

    # $out is where we are installing to and takes precedence
    export PYTHONPATH="$out/${python.sitePackages}:$PYTHONPATH"

    echo "Building setuptools wheel..."

    mkdir wheel

    # install setuptools and setuptools-scm
    ${python}/bin/python -m pip wheel --wheel-dir wheel --no-build-isolation --no-index --no-dependencies --no-cache renamed/setuptools*
    ${python}/bin/python -m pip install --no-build-isolation --no-index --prefix=$out --ignore-installed --no-cache ./wheel/setuptools*


    # install other modules
    for dep in apipkg attrs execnet iniconfig packaging pluggy toml pytest-xdist pyparsing pytest-forked pytest py ${toString extraPnames}; do
      ${python}/bin/python -m pip install --no-build-isolation --no-index --prefix=$out --no-dependencies --ignore-installed --no-cache renamed/$dep
    done
  '';

  checkPhase = ''
    echo checkPhase
    ${python}/bin/python -m pytest --version
  '';

  meta = {
    description = "Standalone pytest package";
    license = lib.unique ([pytest.meta.license] ++ (lib.flatten (lib.forEach allDeps (dep: dep.meta.license or []))));
    homepage = pytest.meta.homepage;
  };
}

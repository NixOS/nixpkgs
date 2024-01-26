{ lib
, stdenv
, pythonOlder
, buildPythonPackage
, fetchFromGitHub
, setuptools-scm
, gmt
, numpy
, netcdf4
, pandas
, packaging
, xarray
, pytest-mpl
, ipython
, ghostscript
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pygmt";
  version = "0.10.0";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "GenericMappingTools";
    repo = "pygmt";
    rev = "refs/tags/v${version}";
    hash = "sha256-+bkjqHjJIwk44u226q6xqeGmwMWleyc4lRfMZdDjVBA=";
  };

  postPatch = ''
    substituteInPlace pygmt/clib/loading.py \
      --replace "env.get(\"GMT_LIBRARY_PATH\", \"\")" "env.get(\"GMT_LIBRARY_PATH\", \"${gmt}/lib\")"
  '';

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    numpy
    netcdf4
    pandas
    packaging
    xarray
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-mpl
    ghostscript
    ipython
  ];

  # The *entire* test suite requires network access
  doCheck = false;

  postBuild = ''
    export HOME=$TMP
  '';

  pythonImportsCheck = [
    "pygmt"
  ];

  meta = with lib; {
    description = "A Python interface for the Generic Mapping Tools";
    homepage = "https://github.com/GenericMappingTools/pygmt";
    license = licenses.bsd3;
    changelog = "https://github.com/GenericMappingTools/pygmt/releases/tag/v${version}";
    # pygmt.exceptions.GMTCLibNotFoundError: Error loading the GMT shared library '/nix/store/r3xnnqgl89vrnq0kzxx0bmjwzks45mz8-gmt-6.1.1/lib/libgmt.dylib'
    broken = stdenv.isDarwin;
    maintainers = with maintainers; [ sikmir ];
  };
}

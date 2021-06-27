{ lib, stdenv
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
  version = "0.3.1";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "GenericMappingTools";
    repo = "pygmt";
    rev = "v${version}";
    sha256 = "0v57n3by9dwckjfmrgf1km4y3gwzj2gk0s9ly64hlaf05zihqnvc";
  };

  postPatch = ''
    substituteInPlace pygmt/clib/loading.py \
      --replace "env.get(\"GMT_LIBRARY_PATH\", \"\")" "env.get(\"GMT_LIBRARY_PATH\", \"${gmt}/lib\")"
  '';

  nativeBuildInputs = [ setuptools-scm ];
  propagatedBuildInputs = [ numpy netcdf4 pandas packaging xarray ];

  doCheck = false; # the *entire* test suite requires network access
  checkInputs = [ pytestCheckHook pytest-mpl ghostscript ipython ];
  postBuild = ''
    export HOME=$TMP
  '';
  pythonImportsCheck = [ "pygmt" ];

  meta = with lib; {
    description = "A Python interface for the Generic Mapping Tools";
    homepage = "https://github.com/GenericMappingTools/pygmt";
    license = licenses.bsd3;
    # pygmt.exceptions.GMTCLibNotFoundError: Error loading the GMT shared library '/nix/store/r3xnnqgl89vrnq0kzxx0bmjwzks45mz8-gmt-6.1.1/lib/libgmt.dylib'
    broken = stdenv.isDarwin;
    maintainers = with maintainers; [ sikmir ];
  };
}

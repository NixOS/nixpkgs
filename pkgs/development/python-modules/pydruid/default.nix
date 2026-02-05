{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  # required dependencies
  requests,
  setuptools,
  # optional dependencies
  pandas,
  tornado,
  sqlalchemy,
  # test dependencies
  pycurl,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pydruid";
  version = "0.6.8";
  format = "setuptools";

  src = fetchFromGitHub {
    repo = "pydruid";
    owner = "druid-io";
    tag = version;
    hash = "sha256-em4UuNnGdfT6KC9XiWSkCmm4DxdvDS+DGY9kw25iepo=";
  };

  # patch out the CLI because it doesn't work with newer versions of pygments
  postPatch = ''
    substituteInPlace setup.py --replace-fail '"console_scripts": ["pydruid = pydruid.console:main"],' ""
  '';

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ requests ];

  nativeCheckInputs = [
    pytestCheckHook
    pycurl
  ]
  ++ lib.concatAttrValues optional-dependencies;

  pythonImportsCheck = [ "pydruid" ];

  optional-dependencies = {
    pandas = [ pandas ];
    async = [ tornado ];
    sqlalchemy = [ sqlalchemy ];
    # druid has a `cli` extra, but it doesn't work with nixpkgs pygments
  };

  meta = {
    description = "Simple API to create, execute, and analyze Druid queries";
    homepage = "https://github.com/druid-io/pydruid";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ cpcloud ];
  };
}

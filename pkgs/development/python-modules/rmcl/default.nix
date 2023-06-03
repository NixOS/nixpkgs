{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, poetry-core
, asks
, trio
, xdg-base-dirs
}:

buildPythonPackage rec {
  pname = "rmcl";
  version = "0.4.2";

  disabled = pythonOlder "3.7";

  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "58de4758e7e3cb7acbf28fcfa80f4155252afdfb191beb4ba4aa36961f66cc67";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace '= "^' '= ">=' \
      --replace 'xdg = ' 'xdg-base-dirs = '
    substituteInPlace rmcl/{config,datacache}.py \
      --replace 'from xdg import' 'from xdg_base_dirs import'
  '';

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    asks
    trio
    xdg-base-dirs
  ];

  # upstream has no tests
  doCheck = false;

  pythonImportsCheck = [ "rmcl" ];

  meta = {
    description = "ReMarkable Cloud Library";
    homepage = "https://github.com/rschroll/rmcl";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}

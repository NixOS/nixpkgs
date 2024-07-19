{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, flit-core
, apeye-core
, domdf-python-tools
, platformdirs
, requests
, cachecontrol
, lockfile
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "apeye";
  version = "1.4.1";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "domdfcoding";
    repo = "apeye";
    rev = "v${version}";
    hash = "sha256-kxFVsGMqOrrelqiiRh7U/VdG/1WTY6MxCKI/keUjBTM=";
  };

  nativeBuildInputs = [
    flit-core
  ];

  propagatedBuildInputs = [
    apeye-core
    domdf-python-tools
    platformdirs
    requests
  ];

  passthru.optional-dependencies = {
    all = lib.flatten (lib.attrValues (lib.filterAttrs (n: v: n != "all") passthru.optional-dependencies));
    limiter = [
      cachecontrol
      lockfile
    ];
  };

  pythonImportsCheck = [ "apeye" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  # requires coincidence which hasn't been packaged yet
  doCheck = false;

  meta = {
    description = "Handy tools for working with URLs and APIs";
    homepage = "https://github.com/domdfcoding/apeye";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}

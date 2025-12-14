{
  lib,
  buildPythonPackage,
  fetchurl,
  nix-update-script,
  numpy,
  pandas,
  python-dateutil,
  pythonOlder,
  pytz,
  setuptools,
  six,
}:

buildPythonPackage rec {
  pname = "pandas-ta";
  version = "0.3.14b";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchurl {
    url = "https://www.pandas-ta.dev/assets/zip/pandas_ta-${version}.tar.gz";
    hash = "sha256-D6Na7IMdKBXqMLhxaIqNIKdrKIp74tJswAw1zYwJqZM=";
  };

  postPatch = ''
    substituteInPlace pandas_ta/momentum/squeeze_pro.py \
      --replace-fail "import NaN" "import nan"
  '';

  build-system = [ setuptools ];

  dependencies = [
    numpy
    pandas
    python-dateutil
    pytz
    setuptools
    six
  ];

  # PyTestCheckHook failing because of missing test dependency. Packages has been tested manually.
  doCheck = false;

  passthru.updateScript = nix-update-script { };

  pythonImportsCheck = [ "pandas_ta" ];

  meta = {
    description = "Technical Analysis Indicators";
    homepage = "https://github.com/twopirllc/pandas-ta";
    changelog = "https://github.com/twopirllc/pandas-ta/blob/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ derdennisop ];
  };
}

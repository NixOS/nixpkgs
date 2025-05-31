{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
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
  version = "0.3.14";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "twopirllc";
    repo = "pandas-ta";
    tag = version;
    hash = "sha256-1s4/u0oN596VIJD94Tb0am3P+WGosRv9ihD+OIMdIBE=";
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

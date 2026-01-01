{
  lib,
  buildPythonPackage,
<<<<<<< HEAD
  fetchurl,
=======
  fetchFromGitHub,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
  version = "0.3.14b";
=======
  version = "0.3.14";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  disabled = pythonOlder "3.7";

<<<<<<< HEAD
  src = fetchurl {
    url = "https://www.pandas-ta.dev/assets/zip/pandas_ta-${version}.tar.gz";
    hash = "sha256-D6Na7IMdKBXqMLhxaIqNIKdrKIp74tJswAw1zYwJqZM=";
=======
  src = fetchFromGitHub {
    owner = "twopirllc";
    repo = "pandas-ta";
    tag = version;
    hash = "sha256-1s4/u0oN596VIJD94Tb0am3P+WGosRv9ihD+OIMdIBE=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
    homepage = "https://www.pandas-ta.dev/";
    license = lib.licenses.unfree;
=======
    homepage = "https://github.com/twopirllc/pandas-ta";
    changelog = "https://github.com/twopirllc/pandas-ta/blob/${version}";
    license = lib.licenses.mit;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = with lib.maintainers; [ derdennisop ];
  };
}

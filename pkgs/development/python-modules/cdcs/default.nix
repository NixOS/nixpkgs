{ lib
, buildPythonPackage
, fetchFromGitHub
, ipython
, numpy
, pandas
, pytestCheckHook
, pythonOlder
, requests
, responses
, setuptools
, tqdm
}:

buildPythonPackage rec {
  pname = "cdcs";
  version = "0.1.9";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "usnistgov";
    repo = "pycdcs";
    # https://github.com/usnistgov/pycdcs/issues/1
    rev = "0a770b752301c27e227ca40a4752f305b55dee20";
    sha256 = "sha256-AUrVEFea4VtBJXWWgECqdBFCqKuHWAlh07Dljp+HBa0=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    ipython
    numpy
    pandas
    requests
    tqdm
  ];

  nativeCheckInputs = [
    pytestCheckHook
    responses
  ];

  pythonImportsCheck = [
    "cdcs"
  ];

  meta = with lib; {
    description = "Python client for performing REST calls to configurable data curation system (CDCS) databases";
    homepage = "https://github.com/usnistgov/pycdcs";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}

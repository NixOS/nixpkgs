{ lib
, buildPythonPackage
, blessings
, fetchFromGitHub
, invoke
, pythonOlder
, releases
, semantic-version
, tabulate
, tqdm
, twine
}:

buildPythonPackage rec {
  pname = "invocations";
  version = "3.0.2";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "pyinvoke";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-sXMxTOi0iCz7Zq0lXkpproUtkId5p/GCqP1TvgqYlME=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "semantic_version>=2.4,<2.7" "semantic_version"
  '';

  propagatedBuildInputs = [
    blessings
    invoke
    releases
    semantic-version
    tabulate
    tqdm
    twine
  ];

  # There's an error loading the test suite. See https://github.com/pyinvoke/invocations/issues/29.
  doCheck = false;

  pythonImportsCheck = [
    "invocations"
  ];

  meta = with lib; {
    description = "Common/best-practice Invoke tasks and collections";
    homepage = "https://invocations.readthedocs.io/";
    changelog = "https://github.com/pyinvoke/invocations/blob/${version}/docs/changelog.rst";
    license = licenses.bsd2;
    maintainers = with maintainers; [ samuela ];
  };
}

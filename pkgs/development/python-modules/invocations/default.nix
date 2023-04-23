{ lib
, buildPythonPackage
, blessings
, fetchFromGitHub
, invoke
, releases
, semantic-version
, tabulate
, tqdm
, twine
}:

buildPythonPackage rec {
  pname = "invocations";
  version = "3.0.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "pyinvoke";
    repo = pname;
    rev = version;
    hash = "sha256-G0sl2DCROxlTnW3lWKeGw4qDmnaeRC4xYf27d6YePjE=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "semantic_version>=2.4,<2.7" "semantic_version" \
      --replace "tabulate==0.7.5" "tabulate"
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
    license = licenses.bsd2;
    maintainers = with maintainers; [ samuela ];
  };
}

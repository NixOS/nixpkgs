{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  lxml,
}:

buildPythonPackage rec {
  pname = "justext";
  version = "3.0.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "miso-belica";
    repo = "jusText";
    rev = "refs/tags/v${version}";
    hash = "sha256-9i7hzCK/ijh8xw9l2ZbVhVj5IBf0WD/49/R1tSWgqrQ=";
  };

  propagatedBuildInputs = [ lxml ];

  nativeCheckInputs = [ pytestCheckHook ];

  # patch out coverage report
  postPatch = ''
    substituteInPlace setup.cfg \
      --replace " --cov=justext --cov-report=term-missing --no-cov-on-fail" ""
  '';

  pythonImportsCheck = [ "justext" ];

  meta = with lib; {
    description = "Heuristic based boilerplate removal tool";
    homepage = "https://github.com/miso-belica/jusText";
    changelog = "https://github.com/miso-belica/jusText/blob/v${version}/CHANGELOG.rst";
    license = licenses.bsd2;
    maintainers = with maintainers; [ jokatzke ];
  };
}

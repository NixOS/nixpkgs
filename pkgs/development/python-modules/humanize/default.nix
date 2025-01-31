{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  freezegun,
  gettext,
  pytestCheckHook,
  pythonOlder,
  python,
  hatch-vcs,
  hatchling,
}:

buildPythonPackage rec {
  pname = "humanize";
  version = "4.11.0";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "python-humanize";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-C6u7t7RedInHJtN4yHli22Wc7llnrxn4YeKssyQ+hS4=";
  };

  nativeBuildInputs = [
    hatch-vcs
    hatchling
    gettext
  ];

  postPatch = ''
    # Remove dependency on pytest-cov
    substituteInPlace pyproject.toml --replace-fail \
      '"ignore:sys.monitoring isn'"'"'t available, using default core:coverage.exceptions.CoverageWarning",' ""
  '';

  postBuild = ''
    scripts/generate-translation-binaries.sh
  '';

  postInstall = ''
    cp -r 'src/humanize/locale' "$out/${python.sitePackages}/humanize/"
  '';

  nativeCheckInputs = [
    freezegun
    pytestCheckHook
  ];

  pythonImportsCheck = [ "humanize" ];

  meta = with lib; {
    description = "Python humanize utilities";
    homepage = "https://github.com/python-humanize/humanize";
    changelog = "https://github.com/python-humanize/humanize/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [
      rmcgibbo
      Luflosi
    ];
  };
}

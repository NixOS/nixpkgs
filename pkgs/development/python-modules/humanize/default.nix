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
  version = "4.12.1";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "python-humanize";
    repo = "humanize";
    tag = version;
    hash = "sha256-sj7c44KQ5jGkmans2EyAn9qMS4+GGu3hcSt7PRiTGKk=";
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

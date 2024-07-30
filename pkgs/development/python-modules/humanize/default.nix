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
  version = "4.10.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "python-humanize";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-zzasFAaWH284IEnWwWKvCL1lt/ItNfdbWhq1K30gSPU=";
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

{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  freezegun,
  gettext,
  pytestCheckHook,
  python,
  hatch-vcs,
  hatchling,
}:

buildPythonPackage rec {
  pname = "humanize";
  version = "4.15.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "python-humanize";
    repo = "humanize";
    tag = version;
    hash = "sha256-EG0QrW4b5NK9+78B0Cs4eAuicIsN/V/77+JxyYrTReA=";
  };

  nativeBuildInputs = [
    hatch-vcs
    hatchling
    gettext
  ];

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

  meta = {
    description = "Python humanize utilities";
    homepage = "https://github.com/python-humanize/humanize";
    changelog = "https://github.com/python-humanize/humanize/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      rmcgibbo
      Luflosi
    ];
  };
}

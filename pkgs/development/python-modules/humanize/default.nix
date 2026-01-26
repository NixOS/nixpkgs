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
  version = "4.12.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "python-humanize";
    repo = "humanize";
    tag = version;
    hash = "sha256-VsB59tS2KRZ0JKd1FzA+RTEzpkUyj9RhhSopseHg+m8=";
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
    changelog = "https://github.com/python-humanize/humanize/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      rmcgibbo
      Luflosi
    ];
  };
}

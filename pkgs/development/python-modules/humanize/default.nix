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
  version = "4.12.2";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "python-humanize";
    repo = "humanize";
    tag = version;
    hash = "sha256-MGWjh7C9JXTwH+eLyrjU0pjcZ2+oH925eiqHgBS8198=";
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

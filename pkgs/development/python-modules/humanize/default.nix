{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  freezegun,
  gettext,
  hatch-vcs,
  hatchling,
  pytest-benchmark,
  pytestCheckHook,
  python,
}:

buildPythonPackage (finalAttrs: {
  pname = "humanize";
  version = "4.16.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "python-humanize";
    repo = "humanize";
    tag = finalAttrs.version;
    hash = "sha256-Ht4lK+Qd6pU4i6MUycaT3j69ldkTRtQ21QzKuLGgrLY=";
  };

  build-system = [
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
    pytest-benchmark
    pytestCheckHook
  ];

  pythonImportsCheck = [ "humanize" ];

  meta = {
    description = "Python humanize utilities";
    homepage = "https://github.com/python-humanize/humanize";
    changelog = "https://github.com/python-humanize/humanize/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      rmcgibbo
      Luflosi
    ];
  };
})

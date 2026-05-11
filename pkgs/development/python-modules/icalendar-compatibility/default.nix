{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  hatch-vcs,
  icalendar,
  pytestCheckHook,
  git,
}:

buildPythonPackage rec {
  pname = "icalendar-compatibility";
  version = "0.1.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "niccokunzmann";
    repo = "icalendar_compatibility";
    tag = "v${version}";
    hash = "sha256-h9rpbltNEPMteicPJ6oC32NsZS8QXQphLbC0Qiu7j5Q=";
  };

  # hatch-vcs tries to read the current git commit hash
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'dynamic = ["urls", "version"]' 'version = "${version}"'
  '';

  build-system = [
    hatchling
    hatch-vcs
  ];

  dependencies = [ icalendar ];

  nativeCheckInputs = [
    pytestCheckHook
    git
  ];

  pythonImportsCheck = [ "icalendar_compatibility" ];

  # env.SETUPTOOLS_SCM_PRETEND_VERSION = version;

  meta = {
    homepage = "https://icalendar-compatibility.readthedocs.io/en/latest/";
    changelog = "https://icalendar-compatibility.readthedocs.io/en/latest/changes.html";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ erictapen ];
  };

}

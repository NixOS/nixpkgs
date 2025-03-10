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
    hash = "sha256-wb7iXj7iQDUiX3zsdtp64W7TYYHv9ZEdtJjIpvqK90M=";
    # hatch-vcs tries to read the current git commit hash
    leaveDotGit = true;
  };

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

  meta = with lib; {
    homepage = "https://icalendar-compatibility.readthedocs.io/en/latest/";
    changelog = "https://icalendar-compatibility.readthedocs.io/en/latest/changes.html";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ erictapen ];
  };

}

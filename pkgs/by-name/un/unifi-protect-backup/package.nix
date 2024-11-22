{
  lib,
  fetchFromGitHub,
  fetchpatch,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "unifi-protect-backup";
  version = "0.11.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ep1cman";
    repo = "unifi-protect-backup";
    rev = "refs/tags/v${version}";
    hash = "sha256-t4AgPFqKS6u9yITIkUUB19/SxVwR7X8Cc01oPx3M+E0=";
  };

  patches = [
    # Switch to using UIProtect library, https://github.com/ep1cman/unifi-protect-backup/pull/160
    (fetchpatch {
      name = "switch-uiprotect.patch";
      url = "https://github.com/ep1cman/unifi-protect-backup/commit/ccf2cde27229ade5c70ebfa902f289bf1a439f64.patch";
      hash = "sha256-kogl/crvLE+7t9DLTuZqeW3/WB5/sytWDgbndoBw+RQ=";
    })
  ];

  pythonRelaxDeps = [
    "aiorun"
    "aiosqlite"
    "click"
    "uiprotect"
  ];

  nativeBuildInputs = with python3.pkgs; [ poetry-core ];

  propagatedBuildInputs = with python3.pkgs; [
    aiocron
    aiolimiter
    aiorun
    aiosqlite
    apprise
    async-lru
    click
    expiring-dict
    python-dateutil
    uiprotect
  ];

  nativeCheckInputs = with python3.pkgs; [ pytestCheckHook ];

  meta = with lib; {
    description = "Python tool to backup unifi event clips in realtime";
    homepage = "https://github.com/ep1cman/unifi-protect-backup";
    changelog = "https://github.com/ep1cman/unifi-protect-backup/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = teams.helsinki-systems.members;
    mainProgram = "unifi-protect-backup";
  };
}

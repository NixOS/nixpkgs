{
  lib,
  fetchFromGitHub,
  fetchpatch,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "xnlinkfinder";
  version = "6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "xnl-h4ck3r";
    repo = "xnLinkFinder";
    tag = "v${version}";
    hash = "sha256-UMHMWHLJOhEeR+vO4YE3aNzdsvMAXPpQHQgdFf1QeMY=";
  };

  patches = [
    # Clean-up setup.py
    (fetchpatch {
      name = "clean-up.patch";
      url = "https://github.com/xnl-h4ck3r/xnLinkFinder/commit/8ef5e2ecf4c627b389cb7bb526f10fffe84acc13.patch";
      hash = "sha256-14j3dFgehhPdqAe4e9FsB8sD66hKnNaPmDJRV1mQTDo=";
    })
  ];

  build-system = with python3.pkgs; [ setuptools ];

  dependencies = with python3.pkgs; [
    beautifulsoup4
    html5lib
    lxml
    psutil
    pyyaml
    requests
    termcolor
    urllib3
  ];

  # Project has no test
  doCheck = false;

  pythonImportsCheck = [ "xnLinkFinder" ];

  meta = {
    description = "Tool to discover endpoints, potential parameters, and a target specific wordlist for a given target";
    homepage = "https://github.com/xnl-h4ck3r/xnLinkFinder";
    changelog = "https://github.com/xnl-h4ck3r/xnLinkFinder/blob/${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "xnLinkFinder";
  };
}

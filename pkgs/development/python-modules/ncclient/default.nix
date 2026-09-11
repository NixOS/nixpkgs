{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  hatch-vcs,
  lxml,
  paramiko,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "ncclient";
  version = "0.7.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ncclient";
    repo = "ncclient";
    tag = "v${version}";
    # Upstream uses .gitattributes to inject information about the revision
    # hash and the refname into `ncclient/_version.py`, see:
    #
    # - https://git-scm.com/docs/gitattributes#_export_subst and
    # - https://github.com/ncclient/ncclient/blob/e056e38af2843de0608da58e2f4662465c96d587/ncclient/_version.py#L25-L28
    postFetch = ''
      sed -i 's/git_refnames = "[^"]*"/git_refnames = " (tag: ${src.tag})"/' $out/ncclient/_version.py
    '';
    hash = "sha256-A1e1YE+RW6mkuhF9eEUPiMiKw3YuHqA+4pNqJpYtAJU=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  dependencies = [
    paramiko
    lxml
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "ncclient" ];

  meta = {
    description = "Python library for NETCONF clients";
    homepage = "https://github.com/ncclient/ncclient";
    changelog = "https://github.com/ncclient/ncclient/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ xnaveira ];
  };
}

{
  appdirs,
  buildPythonPackage,
  click,
  fetchFromGitHub,
  lib,
  pyyaml,
  setuptools-scm,
}:
buildPythonPackage rec {
  pname = "git-autoshare";
  version = "1.0.0b6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "acsone";
    repo = "git-autoshare";
    rev = version;
    sha256 = "sha256-F8wcAayIR6MH8e0cQSwFJn/AVSLG3tVil80APjcFG/0=";
  };

  doCheck = false;

  build-system = [setuptools-scm];
  dependencies = [appdirs click pyyaml];

  meta = with lib; {
    description = "A git clone wrapper that automatically uses --reference to save disk space and download time.";
    homepage = "https://github.com/acsone/git-autoshare";
    license = licenses.gpl3;
    maintainers = with maintainers; [yajo];
  };
}

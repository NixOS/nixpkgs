{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "uwhoisd";
<<<<<<< HEAD
  version = "0.1.2";
=======
  version = "0.1.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kgaughan";
    repo = "uwhoisd";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-Em+SkQ/olmKGntwOG+CUe3x1ZIIH8grOBVxY/a3eVGI=";
=======
    hash = "sha256-ncllROnKFwsSalbkQIOt/sQO0qxybAgxrVnYOC+9InY=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = with python3.pkgs; [
    hatchling
    hatch-vcs
  ];

  dependencies = with python3.pkgs; [
    beautifulsoup4
    requests
  ];

  # Project has no tests
  doCheck = false;

  meta = {
    description = "Universal WHOIS proxy server";
    homepage = "https://github.com/kgaughan/uwhoisd";
<<<<<<< HEAD
    changelog = "https://github.com/kgaughan/uwhoisd/releases/tag/${src.tag}";
=======
    changelog = "https://github.com/kgaughan/uwhoisd/blob/${src.tag}/ChangeLog";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}

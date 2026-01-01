{
  lib,
  buildPythonPackage,
  ddt,
  fetchFromGitHub,
  gitdb,
  pkgs,
<<<<<<< HEAD
  setuptools,
=======
  pythonOlder,
  typing-extensions,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

buildPythonPackage rec {
  pname = "gitpython";
  version = "3.1.45";
<<<<<<< HEAD
  pyproject = true;
=======
  format = "setuptools";

  disabled = pythonOlder "3.7";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "gitpython-developers";
    repo = "GitPython";
    tag = version;
    hash = "sha256-VHnuHliZEc/jiSo/Zi9J/ipAykj7D6NttuzPZiE8svM=";
  };

<<<<<<< HEAD
=======
  propagatedBuildInputs = [
    ddt
    gitdb
    pkgs.gitMinimal
  ]
  ++ lib.optionals (pythonOlder "3.10") [ typing-extensions ];

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  postPatch = ''
    substituteInPlace git/cmd.py \
      --replace 'git_exec_name = "git"' 'git_exec_name = "${pkgs.gitMinimal}/bin/git"'
  '';

<<<<<<< HEAD
  build-system = [ setuptools ];

  dependencies = [
    ddt
    gitdb
    pkgs.gitMinimal
  ];

=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  # Tests require a git repo
  doCheck = false;

  pythonImportsCheck = [ "git" ];

<<<<<<< HEAD
  meta = {
    description = "Python Git Library";
    homepage = "https://github.com/gitpython-developers/GitPython";
    changelog = "https://github.com/gitpython-developers/GitPython/blob/${src.tag}/doc/source/changes.rst";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
=======
  meta = with lib; {
    description = "Python Git Library";
    homepage = "https://github.com/gitpython-developers/GitPython";
    changelog = "https://github.com/gitpython-developers/GitPython/blob/${src.tag}/doc/source/changes.rst";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}

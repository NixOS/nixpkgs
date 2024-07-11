{ python3, runCommand, git, nix, nix-prefetch-git }:

runCommand "update-python-libraries" {
  buildInputs = [
    nix
    nix-prefetch-git
    (python3.withPackages(ps: with ps; [ packaging requests toolz ]))
    git
  ];
} ''
  cp ${./update-python-libraries.py} $out
  patchShebangs $out
  substituteInPlace $out --replace 'GIT = "git"' 'GIT = "${git}/bin/git"'
''

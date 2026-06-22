{
  lib,
  gitMinimal,
  runCommandLocal,
  stdenv,
  wrapper,
}:
/**
  Test that the given project tree is formatted with the treefmt config.

  Input argument is the path to the project tree.
*/
project:
runCommandLocal "${lib.getName wrapper}-check"
  {
    __structuredAttrs = true;
    strictDeps = true;
    nativeBuildInputs = [
      gitMinimal
      wrapper
    ];
    inherit project;
    env = {
      LANG = if stdenv.buildPlatform.isDarwin then "en_US.UTF-8" else "C.UTF-8";
      LC_ALL = if stdenv.buildPlatform.isDarwin then "en_US.UTF-8" else "C.UTF-8";
    };
    meta.description = "Check that the project tree is formatted";
  }
  ''
    # Copy project files into the build-dir
    cp -r "$project" project
    chmod -R a+w project
    cd project

    # Setup a git repo
    git init --initial-branch main
    git config user.name nixbld
    git config user.email nixbld@example.com
    git add .
    git commit -m init --quiet

    # Run treefmt
    treefmt --version
    treefmt --no-cache

    # Ensure nothing changed
    git status
    git --no-pager diff --exit-code
    touch "$out"
  ''

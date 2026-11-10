{
  ast-grep,
  buildPythonPackage,
  flit-core,
}:

buildPythonPackage {
  pname = "ast-grep-cli";
  inherit (ast-grep) version;
  pyproject = true;

  src = ./stub;

  postUnpack = ''
    substituteInPlace "$sourceRoot/pyproject.toml" \
      --subst-var version
  '';

  build-system = [ flit-core ];

  pythonImportsCheck = [ "ast_grep_cli" ];

  meta = {
    inherit (ast-grep.meta)
      description
      homepage
      changelog
      license
      maintainers
      ;
  };
}

{ lib
, callPackage
, buildPythonPackage
, fetchFromGitHub
, mkdocs
}:

buildPythonPackage rec {
  pname = "mkdocs-exclude";
  version = "1.0.2";

  # Repository has only 3 commits and no tags. Each of these commits has
  # version of 1.0.0, 1.0.1 and 1.0.2 in setup.py, though.
  src = fetchFromGitHub {
    owner = "apenwarr";
    repo = "mkdocs-exclude";
    rev = "fdd67d2685ff706de126e99daeaaaf3f6f7cf3ae";
    sha256 = "1phhl79xf4xq8w2sb2w5zm4bahcr33gsbxkz7dl1dws4qhcbxrfd";
  };

  propagatedBuildInputs = [ mkdocs ];

  # Attempt to import "mkdocs_exclude" module in stand-alone mode fails:
  #
  #    module 'mkdocs.config' has no attribute 'config_options'
  #
  # It works fine when actually used to build documentation of "pydantic",
  # though. This package has no tests.
  doCheck = false;

  meta = with lib; {
    description = "A mkdocs plugin to exclude files from input using globs or regexes.";
    homepage = "https://github.com/apenwarr/mkdocs-exclude";
    license = licenses.asl20;
    maintainers = with maintainers; [ kaction ];
  };
}

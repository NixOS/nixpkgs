{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  poetry-core,
}:

buildPythonPackage rec {
  pname = "mawk";
  version = "0.1.4";
  pyproject = true;

  src = fetchFromGitHub {
    repo = "mawk";
    owner = "jhidding";
    tag = "v${version}";
    hash = "sha256-Z/kQ1h+uQWzO4FYJ7Lok9GiXgTHuoQq9icBevPmlVPM=";
  };

  build-system = [
    poetry-core
  ];

  meta = {
    description = "Python implementation of a line processor with Awk-like semanticsn";
    homepage = "https://github.com/jhidding/mawk";
    maintainers = with lib.maintainers; [ mgttlinger ];
    platforms = poetry-core.meta.platforms;
    license = lib.licenses.asl20;
  };
}

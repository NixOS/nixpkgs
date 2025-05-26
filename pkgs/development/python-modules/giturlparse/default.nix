{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  setuptools,
}:
buildPythonPackage rec {
  pname = "giturlparse";
  version = "0.12.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nephila";
    repo = "giturlparse";
    tag = version;
    sha256 = "sha256-VqlsqMLwOtaciBWXphmFAMwtfkWBBNaL1Sdcc8Ltq7k=";
  };

  build-system = [
    setuptools
  ];

  pythonImportsCheck = [ "giturlparse" ];

  meta = {
    description = "Lib to parse & rewrite git urls (supports GitHub, Bitbucket, Assembla ...)";
    homepage = "https://github.com/nephila/giturlparse";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ yajo ];
  };
}

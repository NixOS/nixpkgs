{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  setuptools,
  agate,
  dbf,
  dbfread,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "agate-dbf";
  version = "0.2.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "wireservice";
    repo = "agate-dbf";
    tag = finalAttrs.version;
    hash = "sha256-z68nYig+Z1/C+ys7HmjljdnHhUTqH58iBSbqnLnLFs4=";
  };

  build-system = [ setuptools ];

  dependencies = [
    agate
    dbfread
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    changelog = "https://github.com/wireservice/agate-dbf/blob/${finalAttrs.src.tag}/CHANGELOG.rst";
    description = "Adds read support for dbf files to agate";
    homepage = "https://github.com/wireservice/agate-dbf";
    license = with lib.licenses; [ mit ];
    maintainers = [ ];
  };
})

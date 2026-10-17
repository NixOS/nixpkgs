{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "beanstalkc";
  version = "0.5.2";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "bosondata";
    repo = "beanstalkc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-uvCdSIt5Owsvdn10TXuMGUHTU3Zi6VdntO6KW6MP67Y=";
  };

  build-system = [ setuptools ];

  doCheck = false;

  pythonImportsCheck = [ "beanstalkc" ];

  meta = {
    description = "Simple beanstalkd client library for Python";
    maintainers = with lib.maintainers; [ aanderse ];
    license = lib.licenses.asl20;
    homepage = "https://github.com/bosondata/beanstalkc";
  };
})

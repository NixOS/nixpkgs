{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
}:

buildPythonPackage rec {
  pname = "pyintesishome";
  version = "1.8.5";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "jnimmo";
    repo = "pyIntesisHome";
    tag = version;
    hash = "sha256-QgIvIn8I5EtJSNj1FdOI+DPgG7/y2ToQ62dhk7flieo=";
  };

  propagatedBuildInputs = [ aiohttp ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "pyintesishome" ];

  meta = {
    description = "Python interface for IntesisHome devices";
    homepage = "https://github.com/jnimmo/pyIntesisHome";
    changelog = "https://github.com/jnimmo/pyIntesisHome/releases/tag/${version}";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
  };
}

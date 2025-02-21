{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pyintesishome";
  version = "1.8.5";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "jnimmo";
    repo = "pyIntesisHome";
    rev = "refs/tags/${version}";
    hash = "sha256-QgIvIn8I5EtJSNj1FdOI+DPgG7/y2ToQ62dhk7flieo=";
  };

  propagatedBuildInputs = [ aiohttp ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "pyintesishome" ];

  meta = with lib; {
    description = "Python interface for IntesisHome devices";
    homepage = "https://github.com/jnimmo/pyIntesisHome";
    changelog = "https://github.com/jnimmo/pyIntesisHome/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}

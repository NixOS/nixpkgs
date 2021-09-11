{ lib
, aiohttp
, attrs
, buildPythonPackage
, fetchPypi
, jmespath
, async-timeout
}:

buildPythonPackage rec {
  pname = "pysma";
  version = "0.6.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-ahSc45fIoYvFc0QOt8LV44J3mlJe8uTkwTLJ6cu8gKo=";
  };

  propagatedBuildInputs = [
    aiohttp
    async-timeout
    attrs
    jmespath
  ];

  # pypi does not contain tests and GitHub archive not available
  doCheck = false;
  pythonImportsCheck = [ "pysma" ];

  meta = with lib; {
    description = "Python library for interacting with SMA Solar's WebConnect";
    homepage = "https://github.com/kellerza/pysma";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}

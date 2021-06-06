{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
}:

buildPythonPackage rec {
  pname = "pyintesishome";
  version = "1.7.7";

  src = fetchFromGitHub {
    owner = "jnimmo";
    repo = "pyIntesisHome";
    rev = version;
    sha256 = "1wjh6bib6bg9rf4q9z6dlrf3gncj859hz4i20a9w06jci7b2yaaz";
  };

  propagatedBuildInputs = [
    aiohttp
  ];

  # Project has no tests
  doCheck = false;
  pythonImportsCheck = [ "pyintesishome" ];

  meta = with lib; {
    description = "Python interface for IntesisHome devices";
    homepage = "https://github.com/jnimmo/pyIntesisHome";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}

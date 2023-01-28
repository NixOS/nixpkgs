{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pyalmond";
  version = "0.0.3";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "stanford-oval";
    repo = pname;
    rev = "v${version}";
    sha256 = "0d1w83lr7k2wxcs846iz4mjyqn1ximnw6155kgl515v10fqyrhgk";
  };

  propagatedBuildInputs = [ aiohttp ];

  # Tests require a running Almond instance
  doCheck = false;
  pythonImportsCheck = [ "pyalmond" ];

  meta = with lib; {
    description = "Python client for the Almond API";
    homepage = "https://github.com/stanford-oval/pyalmond";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ fab ];
  };
}

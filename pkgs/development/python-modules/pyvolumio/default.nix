{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pyvolumio";
  version = "0.1.4";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "OnFreund";
    repo = "PyVolumio";
    rev = "v${version}";
    sha256 = "0c6kcz9x0n9w67h2gncyhq0dw3q17nmzipcgx59pwqnn33jan5nf";
  };

  propagatedBuildInputs = [ aiohttp ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "pyvolumio" ];

  meta = with lib; {
    description = "Python module to control Volumio";
    homepage = "https://github.com/OnFreund/PyVolumio";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}

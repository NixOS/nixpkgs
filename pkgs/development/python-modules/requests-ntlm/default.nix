{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  cryptography,
  pyspnego,
  requests,
}:

buildPythonPackage rec {
  pname = "requests-ntlm";
  version = "1.3.0";

  pyproject = true;

  src = fetchPypi {
    pname = "requests_ntlm";
    inherit version;
    hash = "sha256-spzCRiYj3/35uIxD4YDMtzW0AHIopUIiDogsWK5Wxmg=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    cryptography
    pyspnego
    requests
  ];

  pythonImportsCheck = [ "requests_ntlm" ];

  # Tests require networking
  doCheck = false;

  meta = {
    description = "HTTP NTLM authentication support for python-requests";
    homepage = "https://github.com/requests/requests-ntlm";
    changelog = "https://github.com/requests/requests-ntlm/releases/tag/v${version}";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ elasticdog ];
    platforms = lib.platforms.all;
  };
}

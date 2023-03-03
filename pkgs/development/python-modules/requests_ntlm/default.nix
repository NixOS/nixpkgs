{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, cryptography
, pyspnego
, requests
}:

buildPythonPackage rec {
  pname = "requests-ntlm";
  version = "1.2.0";

  format = "pyproject";

  src = fetchPypi {
    pname = "requests_ntlm";
    inherit version;
    hash = "sha256-M8KF9QdOMXy90zjRma+kanwBEy5cER02vUFVNOm5Fqg=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    cryptography
    pyspnego
    requests
  ];

  pythonImportsCheck = [ "requests_ntlm" ];

  # Tests require networking
  doCheck = false;

  meta = with lib; {
    description = "HTTP NTLM authentication support for python-requests";
    homepage = "https://github.com/requests/requests-ntlm";
    changelog = "https://github.com/requests/requests-ntlm/releases/tag/v${version}";
    license = licenses.isc;
    maintainers = with maintainers; [ elasticdog ];
    platforms = platforms.all;
  };
}

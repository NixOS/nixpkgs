{ lib
, buildPythonPackage
, fetchPypi
, mock
, psutil
, pyopenssl
, pysendfile
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pyftpdlib";
  version = "1.5.7";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-fqPOQTfbggmvH2ueoCBZD0YsY+18ehJAvVluTTp7ZW4=";
  };

  propagatedBuildInputs = [
    pysendfile
  ];

  passthru.optional-dependencies = {
    ssl = [
      pyopenssl
    ];
  };

  nativeCheckInputs = [
    mock
    psutil
  ];

  # Impure filesystem-related tests cause timeouts
  # on Hydra: https://hydra.nixos.org/build/84374861
  doCheck = false;

  pythonImportsCheck = [
    "pyftpdlib"
  ];

  meta = with lib; {
    description = "Asynchronous FTP server library";
    homepage = "https://github.com/giampaolo/pyftpdlib/";
    license = licenses.mit;
    maintainers = with maintainers; [ costrouc ];
  };
}

{ lib
, buildPythonPackage
, fetchPypi
, mock
, psutil
, pyopenssl
, pysendfile
}:

buildPythonPackage rec {
  version = "1.5.7";
  pname = "pyftpdlib";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-fqPOQTfbggmvH2ueoCBZD0YsY+18ehJAvVluTTp7ZW4=";
  };

  checkInputs = [ mock psutil ];
  propagatedBuildInputs = [ pyopenssl pysendfile ];

  # impure filesystem-related tests cause timeouts
  # on Hydra: https://hydra.nixos.org/build/84374861
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/giampaolo/pyftpdlib/";
    description = "Very fast asynchronous FTP server library";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}

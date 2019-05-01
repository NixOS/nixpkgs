{ stdenv
, buildPythonPackage
, fetchPypi
, mock
, psutil
, pyopenssl
, pysendfile
, python
}:

buildPythonPackage rec {
  version = "1.5.5";
  pname = "pyftpdlib";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1adf1c03d1508749e7c2f26dc9850ec0ef834318d725b7ae5ac91698f5c86752";
  };

  checkInputs = [ mock psutil ];
  propagatedBuildInputs = [ pyopenssl pysendfile ];

  # impure filesystem-related tests cause timeouts
  # on Hydra: https://hydra.nixos.org/build/84374861
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://github.com/giampaolo/pyftpdlib/;
    description = "Very fast asynchronous FTP server library";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}

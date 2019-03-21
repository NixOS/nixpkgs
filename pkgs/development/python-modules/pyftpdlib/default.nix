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
  version = "1.5.4";
  pname = "pyftpdlib";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e5fca613978743d41c3bfc68e25a811d646a3b8a9eee9eb07021daca89646a0f";
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

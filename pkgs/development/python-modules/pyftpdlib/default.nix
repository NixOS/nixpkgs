{ stdenv
, buildPythonPackage
, fetchPypi
, mock
, psutil
, pyopenssl
, pysendfile
}:

buildPythonPackage rec {
  version = "1.5.6";
  pname = "pyftpdlib";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0pnv2byzmzg84q5nmmhn1xafvfil85qa5y52bj455br93zc5b9px";
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

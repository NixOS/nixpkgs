{ lib
, buildPythonPackage
, fetchgit
, isPy3k
, pyusb
, pybluez
, pytest
, git
}:

buildPythonPackage rec {
  version = "3.0.1";
  pname = "nxt-python";
  format = "setuptools";

  src = fetchgit {
    url = "https://github.com/schodet/nxt-python.git";
    rev = version;
    sha256 = "004c0dr6767bjiddvp0pchcx05falhjzj33rkk03rrl0ha2nhxvz";
  };

  propagatedBuildInputs = [ pyusb pybluez pytest git ];

  meta = with lib; {
    description = "Python driver/interface for Lego Mindstorms NXT robot";
    homepage = "https://github.com/schodet/nxt-python";
    license = licenses.gpl3;
    maintainers = with maintainers; [ ibizaman ];
  };
}

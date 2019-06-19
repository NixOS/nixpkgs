{ stdenv
, fetchurl
, buildPythonPackage
}:
buildPythonPackage {

  pname = "hiredis-py";
  version = "1.0.0";

  src = fetchurl {
    url = "https://files.pythonhosted.org/packages/9e/e0/c160dbdff032ffe68e4b3c576cba3db22d8ceffc9513ae63368296d1bcc8/hiredis-1.0.0.tar.gz";
    sha256 = "e97c953f08729900a5e740f1760305434d62db9f281ac351108d6c4b5bf51795";
  };

  doCheck = false;

  meta = with stdenv.lib; {
    homepage = "http://github.com/redis/hiredis-py";
    license = licenses.bsdOriginal;
    description = "Python extension that wraps protocol parsing code in hiredis. It primarily speeds up parsing of multi bulk replies.";
    maintainers = with maintainers; [ BadDecisionsAlex ];
  };

}

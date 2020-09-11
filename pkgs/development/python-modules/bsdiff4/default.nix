{ stdenv
, buildPythonPackage
, fetchPypi
, aflplusplus
}:

buildPythonPackage rec {
  pname = "bsdiff4";
  version = "1.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "17fc0dd4204x5gqapvbrc4kv83jdajs00jxm739586pl0iapybrw";
  };

  checkPhase = ''
    mv bsdiff4 _bsdiff4
    python -c 'import bsdiff4; bsdiff4.test()'
  '';

  meta = with stdenv.lib; {
    description = "binary diff and patch using the BSDIFF4-format";
    homepage = "https://github.com/ilanschnell/bsdiff4";
    license = licenses.bsdProtection;
    maintainers = with maintainers; [ ris ];
  };
}

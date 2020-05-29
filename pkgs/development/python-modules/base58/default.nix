{ stdenv, fetchPypi, isPy27, buildPythonPackage, pytest, pyhamcrest }:

buildPythonPackage rec {
  pname = "base58";
  version = "2.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0zhp8iwgiapaqwpy67agzfg1lwnj59zi61s3cgfm5p0pp6l88df8";
  };

  checkInputs = [ pytest pyhamcrest ];
  checkPhase = ''
    pytest
  '';

  disabled = isPy27;

  meta = with stdenv.lib; {
    description = "Base58 and Base58Check implementation";
    homepage = "https://github.com/keis/base58";
    license = licenses.mit;
    maintainers = with maintainers; [ nyanloutre ];
  };
}

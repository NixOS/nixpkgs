{ stdenv, buildPythonPackage, fetchPypi}:

buildPythonPackage rec {
  pname = "gorilla";
  version = "0.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "feb2899b923935c25420b94aa8c266ccb5c0315199c685b725303a73195d802c";
  };

  meta = with stdenv.lib; {
    homepage = "https://github.com/christophercrouzet/gorilla";
    description = "Convenient approach to monkey patching";
    license = licenses.mit;
    maintainers = with maintainers; [ tbenst ];
  };
}

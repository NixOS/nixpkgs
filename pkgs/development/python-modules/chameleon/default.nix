{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "Chameleon";
  version = "3.7.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7adc331eb039d5c458cd78e42a76f8e470953f004ddf297bd57aa1501392aec9";
  };

  meta = with stdenv.lib; {
    homepage = "https://chameleon.readthedocs.io/";
    description = "Fast HTML/XML Template Compiler";
    license = licenses.bsd0;
    maintainers = with maintainers; [ domenkozar ];
  };

}

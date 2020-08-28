{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "Chameleon";
  version = "3.8.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "adf9609a2fa4ad20deb390605495f9a5d617b737bfbd86e51a49bbac2acaf316";
  };

  meta = with stdenv.lib; {
    homepage = "https://chameleon.readthedocs.io/";
    description = "Fast HTML/XML Template Compiler";
    license = licenses.bsd0;
    maintainers = with maintainers; [ domenkozar ];
  };

}

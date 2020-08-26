{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "Chameleon";
  version = "3.7.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "37c01c9af720bc80a0097ebc07eb41e802917ad0006c9a77dc158479c087664b";
  };

  meta = with stdenv.lib; {
    homepage = "https://chameleon.readthedocs.io/";
    description = "Fast HTML/XML Template Compiler";
    license = licenses.bsd0;
    maintainers = with maintainers; [ domenkozar ];
  };

}

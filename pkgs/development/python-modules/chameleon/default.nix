{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "Chameleon";
  version = "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0141kfwx553q73wzfl624pppmbhh7fpzvaj5pbj21pqlk2rhfx75";
  };

  meta = with stdenv.lib; {
    homepage = https://chameleon.readthedocs.io/;
    description = "Fast HTML/XML Template Compiler";
    license = licenses.bsd0;
    maintainers = with maintainers; [ garbas domenkozar ];
  };

}

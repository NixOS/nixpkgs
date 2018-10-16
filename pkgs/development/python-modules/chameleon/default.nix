{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "Chameleon";
  version = "2.25";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0va95cml7wfjpvgj3dc9xdn8psyjh3zbk6v51b0hcqv2fzh409vb";
  };

  meta = with stdenv.lib; {
    homepage = https://chameleon.readthedocs.io/;
    description = "Fast HTML/XML Template Compiler";
    license = licenses.bsd0;
    maintainers = with maintainers; [ garbas domenkozar ];
  };

}

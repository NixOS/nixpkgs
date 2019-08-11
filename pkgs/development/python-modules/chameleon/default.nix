{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "Chameleon";
  version = "3.6.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0aw6cqnychmsxjjgihwr7df92xw6ac1wr4x70mvq28z3iq35x7ls";
  };

  meta = with stdenv.lib; {
    homepage = https://chameleon.readthedocs.io/;
    description = "Fast HTML/XML Template Compiler";
    license = licenses.bsd0;
    maintainers = with maintainers; [ domenkozar ];
  };

}

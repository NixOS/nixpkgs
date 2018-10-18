{ stdenv
, buildPythonPackage
, fetchPypi
, rope
, flake8
, autopep8
, jedi
, importmagic
, isPy27
}:

buildPythonPackage rec {
  pname = "elpy";
  version = "1.9.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "419f7b05b19182bc1aedde1ae80812c1534e59a0493476aa01ea819e76ba26f0";
  };

  propagatedBuildInputs = [ flake8 autopep8 jedi importmagic ]
    ++ stdenv.lib.optionals isPy27 [ rope ];

  doCheck = false; # there are no tests

  meta = with stdenv.lib; {
    description = "Backend for the elpy Emacs mode";
    homepage = "https://github.com/jorgenschaefer/elpy";
    license = licenses.gpl3;
  };

}

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
  version = "1.28.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0lx6bf6ajx6wmnns03gva5sh1mmmxahjaqrn735cgwn6j4ikyqfs";
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

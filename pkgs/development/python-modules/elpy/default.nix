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
  version = "1.25.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "10n20lw7n728ahnfrx03vgx9zim7jb8s1zqhw8yivksm9c1a6i12";
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

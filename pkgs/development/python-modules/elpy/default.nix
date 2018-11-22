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
  version = "1.26.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1m3dk609sn1j8zk8xwrlgcw82vkpws4q4aypv2ljpky9lm36npv6";
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

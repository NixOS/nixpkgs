{ stdenv, buildPythonPackage, fetchPypi, termcolor, pytest }:

buildPythonPackage rec {
  pname = "pytest-sugar";
  version = "0.9.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "fcd87a74b2bce5386d244b49ad60549bfbc4602527797fac167da147983f58ab";
  };

  propagatedBuildInputs = [ termcolor pytest ];

  checkPhase = ''
    py.test
  '';

  meta = with stdenv.lib; {
    description = "A plugin that changes the default look and feel of py.test";
    homepage = https://github.com/Frozenball/pytest-sugar;
    license = licenses.bsd3;

    # incompatible with pytest 3.5
    # https://github.com/Frozenball/pytest-sugar/issues/134
    broken = true; # 2018-04-20
  };
}

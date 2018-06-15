{ stdenv, buildPythonPackage, fetchPypi, termcolor, pytest }:

buildPythonPackage rec {
  pname = "pytest-sugar";
  version = "0.9.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ab8cc42faf121344a4e9b13f39a51257f26f410e416c52ea11078cdd00d98a2c";
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

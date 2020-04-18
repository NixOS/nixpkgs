{ stdenv
, buildPythonPackage
, fetchPypi
, setuptools_scm
# , backports
, python
}:

buildPythonPackage rec {
  pname = "backports.weakref";
  version = "1.0.post1";
  src = fetchPypi {
    inherit pname version;
    sha256 = "bc4170a29915f8b22c9e7c4939701859650f2eb84184aee80da329ac0b9825c2";
  };

  buildInputs = [ setuptools_scm ];
#   checkInputs = [ backports ];

  # Requires backports package
  doCheck = false;

  checkPhase = ''
    ${python.interpreter} -m unittest discover tests
  '';

  meta = with stdenv.lib; {
    description = "Backports of new features in Python’s weakref module";
    license = licenses.psfl;
    maintainers = with maintainers; [ jyp ];
  };
}

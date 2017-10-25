{ stdenv
, buildPythonPackage
, fetchPypi
, setuptools_scm
# , backports
, python
}:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "backports.weakref";
  version = "1.0rc1";
  src = fetchPypi {
    inherit pname version;
    sha256 = "14i8m3lspykdfpzf50grij3z286j9q8f32f2bnwdicv659qvy4w8";
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

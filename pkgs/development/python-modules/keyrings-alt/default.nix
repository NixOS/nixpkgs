{ stdenv, buildPythonPackage, fetchPypi, six
, pytest, unittest2, mock, keyring, setuptools_scm
}:

buildPythonPackage rec {
  pname = "keyrings.alt";
  version = "3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0nnva8g03dv6gdhjk1ihn2qw7g15232fyj8shipah9whgfv8d75m";
  };

  nativeBuildInputs = [ setuptools_scm ];
  propagatedBuildInputs = [ six ];

  # Fails with "ImportError: cannot import name mock"
  doCheck = false;
  checkInputs = [ pytest unittest2 mock keyring ];

  meta = with stdenv.lib; {
    license = licenses.mit;
    description = "Alternate keyring implementations";
    homepage = https://github.com/jaraco/keyrings.alt;
    maintainers = with maintainers; [ nyarly ];
  };
}

{ buildPythonPackage, fetchPypi, isPy27, setuptools_scm, six, more-itertools }:

buildPythonPackage rec {
  pname = "jaraco.classes";
  version = "3.1.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1avsxzm5mwylmy2zbxq3xvn48z5djb0qy3hwv4ryncprivzri1n3";
  };

  nativeBuildInputs = [ setuptools_scm ];
  propagatedBuildInputs = [ six more-itertools ];

  doCheck = false;
}

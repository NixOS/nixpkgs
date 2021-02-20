{ buildPythonPackage, fetchPypi, isPy27, setuptools_scm, six, more-itertools }:

buildPythonPackage rec {
  pname = "jaraco.classes";
  version = "3.1.1";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "92bf5d4e6957b17f21034c956dc90977f8ef496c3919ccb165f457f0e2f63cac";
  };

  pythonNamespaces = [ "jaraco" ];

  nativeBuildInputs = [ setuptools_scm ];
  propagatedBuildInputs = [ six more-itertools ];

  doCheck = false;
}

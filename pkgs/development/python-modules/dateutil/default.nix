{ stdenv, buildPythonPackage, fetchPypi, six, setuptools_scm }:
buildPythonPackage rec {
  pname = "python-dateutil";
  version = "2.7.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "88f9287c0174266bb0d8cedd395cfba9c58e87e5ad86b2ce58859bc11be3cf02";
  };

  propagatedBuildInputs = [ six setuptools_scm ];

  meta = with stdenv.lib; {
    description = "Powerful extensions to the standard datetime module";
    homepage = https://pypi.python.org/pypi/python-dateutil;
    license = "BSD-style";
  };
}

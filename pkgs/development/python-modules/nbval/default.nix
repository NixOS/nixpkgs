{ stdenv
, buildPythonPackage
, fetchPypi
, six
, pytest
, nbformat
, jupyter_client
, ipykernel
, coverage
, glibcLocales
, nbdime
}:

buildPythonPackage rec {
  pname = "nbval";
  version = "0.9.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3f18b87af4e94ccd073263dd58cd3eebabe9f5e4d6ab535b39d3af64811c7eda";
  };

  buildInputs = [ glibcLocales ];
  checkInputs = [ pytest nbdime ];
  propagatedBuildInputs = [ six pytest nbformat jupyter_client ipykernel coverage ];

  LC_ALL="en_US.utf8";

  meta = with stdenv.lib; {
    description = "A py.test plugin to validate Jupyter notebooks";
    homepage = https://github.com/computationalmodelling/nbval;
    license = licenses.free;
    maintainers = [ maintainers.costrouc ];
  };
}

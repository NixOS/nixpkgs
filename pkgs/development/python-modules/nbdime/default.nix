{ stdenv
, buildPythonPackage
, fetchPypi
, backports_functools_lru_cache
, backports-shutil-which
, jinja2
, notebook
, GitPython
, requests
, tornado
, colorama
, six
, nbformat
, tabulate
, mock
, jsonschema
, pytest
, pytest-tornado5
, pytest-timeout
, isPy27
}:

buildPythonPackage rec {
  pname = "nbdime";
  version = "1.0.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "763f21816a5ab2cc720cdfbcc6073cf0dc611ed8ed592741cfc3916843433a47";
  };

  checkInputs = [ tabulate mock jsonschema pytest pytest-tornado5 pytest-timeout ];
  propagatedBuildInputs = [ jinja2 notebook GitPython requests tornado colorama six nbformat ]
  ++ stdenv.lib.optionals isPy27 [ backports_functools_lru_cache backports-shutil-which ];

  meta = with stdenv.lib; {
    description = "Diff and merge of Jupyter Notebooks";
    homepage = http://jupyter.org;
    license = licenses.bsdOriginal;
    maintainers = [ maintainers.costrouc ];
  };
}

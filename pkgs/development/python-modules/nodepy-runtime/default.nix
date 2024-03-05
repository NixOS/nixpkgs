{ lib
, buildPythonPackage
, fetchPypi
, localimport
, pathlib2
, six
}:

buildPythonPackage rec {
  pname = "nodepy-runtime";
  version = "2.1.5";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-6tSsD76EpCZxkdulv1BcUZtIXGWLG6PuII25J8STygE=";
  };

  propagatedBuildInputs = [
    localimport
    pathlib2
    six
  ];

  pythonImportsCheck = [
    "nodepy"
  ];

  meta = with lib; {
    homepage = "https://github.com/nodepy/nodepy";
    description = "Runtime for Python inspired by Node.JS";
    longDescription = ''
      Node.py is a Python runtime and package manager compatible with CPython
      2.7 and 3.3 – 3.6. It provides a separate import mechanism for modules
      inspired by Node.js, bringing dependency management and ease of deployment
      for Python applications up to par with other languages without virtual
      environments.

      Node.py comes with a built-in package manager that builds on Pip for
      standard Python dependencies but also adds the capability to install
      packages that are specifically developed for Node.py. To install the
      dependencies of the package manager you must specify the [pm] install
      extra.
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ AndersonTorres ];
  };
}

{ stdenv
, jedi, mccabe, future, futures, rope, tox
, yapf, pycodestyle, pluggy, pyflakes
, json-rpc
, pydocstyle, pytest, mock, versioneer, autopep8
, fetchPypi
, buildPythonPackage
, pythonOlder
, configparser ? null
}:
buildPythonPackage rec {

  pname = "python-language-server";
  version = "0.18.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0n106b92xdkp9pqk6qrsgh5qm7gvzskyjhkbj4sjj55rkwadsmij";
  };

  postPatch = stdenv.lib.optionalString (!pythonOlder "3.0") ''
    substituteInPlace setup.py --replace 'configparser'  ""
  '';

  propagatedBuildInputs = [
    future
    mccabe
    jedi
    json-rpc
    yapf
    pycodestyle
    pydocstyle
    pyflakes
    pluggy
    rope
  ]
  ++ stdenv.lib.optionals (pythonOlder "3.0") [ configparser ]
  ++ stdenv.lib.optionals (pythonOlder "3.2") [ futures ];

  checkInputs = [ autopep8 versioneer pytest mock ];

  checkPhase = ''
    py.test
  '';

  meta = with stdenv.lib; {
    homepage = http://github.com/palantir/python-language-server;
    description = "Language Server for Python";
    license = licenses.mit;
  };
}


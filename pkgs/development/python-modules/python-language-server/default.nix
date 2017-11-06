{ stdenv
, jedi, mccabe, future, futures, rope, tox
, yapf, pycodestyle, pluggy, pyflakes
, json-rpc, pydocstyle, pytest
, fetchPypi
, buildPythonPackage
, pythonOlder
, configparser ? null
}:
buildPythonPackage rec {

  pname = "python-language-server";
  version = "0.16.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1sp9wyna44izw0ygb4m73v5g04fhqbpypkvfc7lqzyb22dp54a2a";
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
  ] ++ stdenv.lib.optionals (pythonOlder "3.0") [ configparser futures ];

  checkInputs = [ pytest ];

  checkPhase = ''
    py.test
  '';

  meta = with stdenv.lib; {
    homepage = http://github.com/palantir/python-language-server;
    description = "Language Server for Python";
    license = licenses.mit;
  };
}


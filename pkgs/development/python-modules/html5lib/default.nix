{ lib
, buildPythonPackage
, fetchPypi
, flake8
, pytest_4
, pytest-expect
, mock
, six
, webencodings
}:

buildPythonPackage rec {
  pname = "html5lib";
  version = "1.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "66cb0dcfdbbc4f9c3ba1a63fdb511ffdbd4f513b2b6d81b80cd26ce6b3fb3736";
  };

  checkInputs = [ flake8 pytest_4 pytest-expect mock ];
  propagatedBuildInputs = [
    six webencodings
  ];

  checkPhase = ''
    # remove test causing error
    # https://github.com/html5lib/html5lib-python/issues/411
    rm html5lib/tests/test_stream.py
    py.test
  '';

  meta = {
    homepage = https://github.com/html5lib/html5lib-python;
    downloadPage = https://github.com/html5lib/html5lib-python/releases;
    description = "HTML parser based on WHAT-WG HTML5 specification";
    longDescription = ''
      html5lib is a pure-python library for parsing HTML. It is designed to
      conform to the WHATWG HTML specification, as is implemented by all
      major web browsers.
    '';
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ domenkozar prikhi ];
  };
}

{ lib
, buildPythonPackage
, fetchPypi
, flake8
, pytest
, pytest-expect
, mock
, six
, webencodings
}:

buildPythonPackage rec {
  pname = "html5lib";
  version = "0.999999999";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1632ak23y4j78jdm24s6iqyf2kzfcmf6p4v141rd4a1hzl7pqx7f";
  };

  checkInputs = [ flake8 pytest pytest-expect mock ];
  propagatedBuildInputs = [
    six webencodings
  ];

  checkPhase = ''
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
{ buildPythonPackage, fetchPypi, fetchpatch, python, stdenv, parse }:

let
  # pyparser only builds with parse == 1.6.5
  parse = buildPythonPackage rec {
    pname = "parse";
    version = "1.6.5";

    src = fetchPypi {
      inherit pname version;
      sha256 = "0wiskj9i2lr52mfm4hzy2hpw1pv3li1p91y2a9dxw3kbp9a52m69";
    };

    patches = [
      (fetchpatch {
        name = "python-3.5-tests-compat.patch";
        url = "https://github.com/r1chardj0n3s/parse/pull/34.patch";
        sha256 = "16iicgkf3lwivmdnp3xkq4n87wjmr3nb77z8mwz67b7by9nnp3jg";
      })
    ];

    checkPhase = ''
      ${python.interpreter} test_parse.py
    '';

    meta = with stdenv.lib; {
      homepage = https://github.com/r1chardj0n3s/parse;
      description = "parse() is the opposite of format()";
      license = licenses.bsdOriginal;
      maintainers = with maintainers; [ alunduil ];
    };
  };
in
buildPythonPackage rec {
  pname = "pyparser";
  version = "1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1x8jp48kzxav3l1il5xz61hyxbs4q6f24ifmvz554afxmcnnxdyi";
  };

  buildInputs = [
    parse
  ];

  doCheck = false; # ImportError: No module named tests

  meta = {
    homepage    = "http://bitbucket.org/rw_grim/pyparser";
    description = "A collection of classes to make it easier to parse text data in a pythonic way";
    license     = stdenv.lib.licenses.mit;
    maintainers = with stdenv.lib.maintainers; [ matthiasbeyer ];
  };
}


{ stdenv, fetchPypi, fetchpatch
, buildPythonPackage, python
}:
buildPythonPackage rec {
  pname = "parse";
  version = "1.6.6";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "71435aaac494e08cec76de646de2aab8392c114e56fe3f81c565ecc7eb886178";
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
}

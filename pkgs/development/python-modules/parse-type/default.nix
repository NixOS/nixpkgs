{ stdenv, fetchPypi, fetchpatch
, buildPythonPackage, pythonOlder
, pytest, pytestrunner
, parse, six, enum34
}:

buildPythonPackage rec {
  pname = "parse_type";
  version = "0.3.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3dd0b323bafcb8c25e000ce5589042a1c99cba9c3bec77b9f591e46bc9606147";
  };

  patches = [
    (fetchpatch {
      name = "python-3.5-tests-compat.patch";
      url = "https://github.com/jenisys/parse_type/pull/4.patch";
      sha256 = "1mmn2fxss6q3qhaydd4s4v8vjgvgkg41v1vcivrzdsvgsc3npg7m";
    })
  ];

  checkInputs = [ pytest pytestrunner ];
  propagatedBuildInputs = [ parse six ] ++ stdenv.lib.optional (pythonOlder "3.4") enum34;

  checkPhase = ''
    py.test tests
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/jenisys/parse_type;
    description = "Simplifies to build parse types based on the parse module";
    license = licenses.bsd3;
    maintainers = with maintainers; [ alunduil ];
  };
}

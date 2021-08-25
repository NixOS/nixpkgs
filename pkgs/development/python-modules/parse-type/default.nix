{ lib, fetchFromGitHub
, buildPythonPackage, pythonOlder
, pytest, pytest-runner
, parse, six, enum34
}:

buildPythonPackage rec {
  pname = "parse-type";
  version = "0.5.6";

  src = fetchFromGitHub {
    owner = "jenisys";
    repo = "parse_type";
    rev = "v${version}";
    sha256 = "sha256-CJroqJIi5DpmR8i1lr8OJ+234615PhpVUsqK91XOT3E=";
  };
  checkInputs = [ pytest pytest-runner ];
  propagatedBuildInputs = [ parse six ] ++ lib.optional (pythonOlder "3.4") enum34;

  postPatch = ''
    substituteInPlace pytest.ini \
      --replace "--metadata PACKAGE_UNDER_TEST parse_type" "" \
      --replace "--metadata PACKAGE_VERSION 0.5.6" "" \
      --replace "--html=build/testing/report.html --self-contained-html" "" \
      --replace "--junit-xml=build/testing/report.xml" ""
  '';

  checkPhase = ''
    py.test tests
  '';

  meta = with lib; {
    homepage = "https://github.com/jenisys/parse_type";
    description = "Simplifies to build parse types based on the parse module";
    license = licenses.bsd3;
    maintainers = with maintainers; [ alunduil ];
  };
}

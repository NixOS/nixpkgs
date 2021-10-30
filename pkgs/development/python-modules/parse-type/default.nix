{ lib
, buildPythonPackage
, fetchFromGitHub
, parse
, pytestCheckHook
, pythonOlder
, six
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

  propagatedBuildInputs = [
    parse
    six
  ];

  checkInputs = [
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace pytest.ini \
      --replace "--metadata PACKAGE_UNDER_TEST parse_type" "" \
      --replace "--metadata PACKAGE_VERSION 0.5.6" "" \
      --replace "--html=build/testing/report.html --self-contained-html" "" \
      --replace "--junit-xml=build/testing/report.xml" ""
  '';

  pythonImportsCheck = [ "parse_type" ];

  meta = with lib; {
    description = "Simplifies to build parse types based on the parse module";
    homepage = "https://github.com/jenisys/parse_type";
    license = licenses.bsd3;
    maintainers = with maintainers; [ alunduil ];
  };
}

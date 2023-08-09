{ lib
, buildPythonPackage
, fetchFromGitHub
, parse
, pytestCheckHook
, six
}:

buildPythonPackage rec {
  pname = "parse-type";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "jenisys";
    repo = "parse_type";
    rev = "v${version}";
    hash = "sha256-v79zzAAwXYoK2N8ZPl1L90qOwMRexAV2wCTMvo4vrSc=";
  };

  propagatedBuildInputs = [
    parse
    six
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace pytest.ini \
      --replace "--metadata PACKAGE_UNDER_TEST parse_type" "" \
      --replace "--metadata PACKAGE_VERSION ${version}" "" \
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

{ lib
, buildPythonPackage
, fetchFromGitHub
, pbr
, calmjs-parse
, certifi
, chardet
, idna
, ply
, requests
, urllib3
, httpretty
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "eebrightbox";
  version = "0.0.6";

  src = fetchFromGitHub {
    owner = "krygal";
    repo = "eebrightbox";
    rev = version;
    sha256 = "1kms240g01871qbvyc5rzf86yxsrlnfvp323jh4k35fpf45z44rr";
  };

  postPatch = ''
    substituteInPlace requirements.txt --replace "==" ">="
  '';

  nativeBuildInputs = [
    pbr
  ];

  PBR_VERSION = version;

  propagatedBuildInputs = [
    calmjs-parse
    certifi
    chardet
    idna
    ply
    requests
    urllib3
  ];

  checkInputs = [
    httpretty
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Connector for EE BrightBox routers";
    homepage = "https://github.com/krygal/eebrightbox";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}

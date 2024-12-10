{ lib, buildDunePackage, fetchFromGitHub
, menhir, menhirLib, ppx_deriving_yojson, visitors, yojson
}:

buildDunePackage rec {
  pname = "morbig";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "colis-anr";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-fOBaJHHP/Imi9UDLflI52OdKDcmMxpl+NH3pfofmv/o=";
  };

  duneVersion = "3";

  nativeBuildInputs = [
    menhir
  ];

  propagatedBuildInputs = [
    menhirLib
    ppx_deriving_yojson
    visitors
    yojson
  ];

  meta = with lib; {
    homepage = "https://github.com/colis-anr/${pname}";
    description = "Static parser for POSIX Shell";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ niols ];
  };
}

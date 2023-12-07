{ lib
, buildPythonPackage
, fetchFromGitHub
, chardet
, nose
}:

buildPythonPackage rec {
  pname = "pysrt";
  version = "1.1.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "byroot";
    repo = "pysrt";
    rev = "v${version}";
    sha256 = "1f5hxyzlh5mdvvi52qapys9qcinffr6ghgivb6k4jxa92cbs3mfg";
  };

  nativeCheckInputs = [ nose ];
  checkPhase = ''
    nosetests -v
  '';

  propagatedBuildInputs = [ chardet ];

  meta = with lib; {
    homepage = "https://github.com/byroot/pysrt";
    license = licenses.gpl3;
    description = "Python library used to edit or create SubRip files";
  };
}

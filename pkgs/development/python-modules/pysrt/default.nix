{ stdenv
, buildPythonPackage
, fetchFromGitHub
, chardet
, nose
}:

buildPythonPackage rec {
  pname = "pysrt";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "byroot";
    repo = "pysrt";
    rev = "v${version}";
    sha256 = "0rwjaf26885vxhxnas5d8zwasvj7x88y4y2pdivjd4vdcpqrqdjn";
  };

  checkInputs = [ nose ];
  checkPhase = ''
    nosetests -v
  '';

  propagatedBuildInputs = [ chardet ];

  meta = with stdenv.lib; {
    homepage = https://github.com/byroot/pysrt;
    license = licenses.gpl3;
    description = "Python library used to edit or create SubRip files";
  };
}

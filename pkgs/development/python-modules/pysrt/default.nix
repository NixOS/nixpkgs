{ stdenv
, buildPythonApplication
, fetchurl
, chardet
}:

buildPythonApplication rec {
  name = "pysrt-${version}";
  version = "1.1.1";

  src = fetchurl {
    url = "mirror://pypi/p/pysrt/${name}.tar.gz";
    sha256 = "1anhfilhamdv15w9mmzwc5a8fsri00ghkmcws4r5mz298m110k7v";
  };

  propagatedBuildInputs = [ chardet ];

  meta = with stdenv.lib; {
    homepage = https://github.com/byroot/pysrt;
    license = licenses.gpl3;
    description = "Python library used to edit or create SubRip files";
  };
}

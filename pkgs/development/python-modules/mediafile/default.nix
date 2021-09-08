{ buildPythonPackage
, fetchPypi
, lib
, mutagen
, six
}:

buildPythonPackage rec {
  pname = "mediafile";
  version = "0.8.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-19K5DZMstRWu/6+N/McEdM1swedI5qr15kmnIAMA60Y=";
  };

  propagatedBuildInputs = [ mutagen six ];

  meta = with lib; {
    description = "MediaFile is a simple interface to the metadata tags for many audio file formats.";
    homepage = "https://github.com/beetbox/mediafile";
    license = licenses.mit;
    maintainers = with maintainers; [ lovesegfault ];
  };
}

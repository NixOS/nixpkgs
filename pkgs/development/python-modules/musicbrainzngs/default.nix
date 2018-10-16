{ stdenv
, buildPythonPackage
, fetchPypi
, pkgs
}:

buildPythonPackage rec {
  pname = "musicbrainzngs";
  version = "0.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "281388ab750d2996e9feca4580fd4215d616a698e02cd6719cb9b8562945c489";
  };

  buildInputs = [ pkgs.glibcLocales ];

  LC_ALL="en_US.UTF-8";

  meta = with stdenv.lib; {
    homepage = http://alastair/python-musicbrainz-ngs;
    description = "Python bindings for musicbrainz NGS webservice";
    license = licenses.bsd2;
    maintainers = with maintainers; [ domenkozar ];
  };

}

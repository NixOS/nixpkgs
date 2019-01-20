{ stdenv
, buildPythonPackage
, fetchurl
, pythonOlder
}:

buildPythonPackage rec {
  name = "Django-${version}";
  version = "1.8.19";

  src = fetchurl {
    url = "http://www.djangoproject.com/m/releases/1.8/${name}.tar.gz";
    sha256 = "0iy0ni9j1rnx9b06ycgbg2dkrf3qid3y2jipk9x28cykz5f4mm1k";
  };

  # too complicated to setup
  doCheck = false;

  # patch only $out/bin to avoid problems with starter templates (see #3134)
  postFixup = ''
    wrapPythonProgramsIn $out/bin "$out $pythonPath"
  '';

  meta = with stdenv.lib; {
    description = "A high-level Python Web framework";
    homepage = https://www.djangoproject.com/;
    license = licenses.bsd0;
  };

}

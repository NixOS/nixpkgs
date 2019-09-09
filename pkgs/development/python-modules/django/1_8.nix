{ stdenv
, buildPythonPackage
, fetchurl
}:

buildPythonPackage rec {
  pname = "Django";
  version = "1.8.19";

  src = fetchurl {
    url = "http://www.djangoproject.com/m/releases/1.8/${pname}-${version}.tar.gz";
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
    knownVulnerabilities = [
      # The patches were not backported due to Django 1.8 having reached EOL
      https://www.djangoproject.com/weblog/2018/aug/01/security-releases/
      https://www.djangoproject.com/weblog/2019/jan/04/security-releases/
      https://www.djangoproject.com/weblog/2019/feb/11/security-releases/
      https://www.djangoproject.com/weblog/2019/jun/03/security-releases/
      https://www.djangoproject.com/weblog/2019/jul/01/security-releases/
    ];
  };

}

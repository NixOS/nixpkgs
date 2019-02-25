{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  version = "0.5.1";
  pname = "grappelli_safe";

  src = fetchPypi {
    inherit pname version;
    sha256 = "27660faa628186d74258781edfa03ef812555d49b4925cfe19c05bcd3da85e40";
  };

  meta = with stdenv.lib; {
    description = "A snapshot of django-grappelli for the Mezzanine CMS";
    longDescription = ''
      grappelli_safe was created to provide a snapshot of the
      Grappelli admin skin for Django, to be referenced as a
      dependency for the Mezzanine CMS for Django.

      At the time of grappelli_safe's creation, Grappelli was
      incorrectly packaged on PyPI, and had also dropped compatibility
      with Django 1.1 - grappelli_safe was therefore created to
      address these specific issues.
    '';
    homepage = https://github.com/stephenmcd/grappelli-safe;
    downloadPage = http://pypi.python.org/pypi/grappelli_safe/;
    license = licenses.free;
    maintainers = with maintainers; [ prikhi ];
    platforms = platforms.unix;
  };

}

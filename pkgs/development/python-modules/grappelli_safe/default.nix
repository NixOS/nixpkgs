{ lib
, buildPythonPackage
, fetchFromGitHub
}:

buildPythonPackage rec {
  version = "0.5.2";
  pname = "grappelli_safe";

  src = fetchFromGitHub {
     owner = "stephenmcd";
     repo = "grappelli-safe";
     rev = "v0.5.2";
     sha256 = "0k0j3173wai3w0b61mndxvy2ad6qbydrafj4ll0k172dgawz2cb8";
  };

  meta = with lib; {
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
    homepage = "https://github.com/stephenmcd/grappelli-safe";
    downloadPage = "http://pypi.python.org/pypi/grappelli_safe/";
    license = licenses.free;
    maintainers = with maintainers; [ prikhi ];
    platforms = platforms.unix;
  };

}

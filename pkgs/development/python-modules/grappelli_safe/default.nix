{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  version = "0.5.2";
  pname = "grappelli_safe";

  src = fetchPypi {
    inherit pname version;
    sha256 = "35b7ccaf9acc54684c73aeefbeaddc63b8a16143bd981bd5b3ebef253def07df";
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
    homepage = "https://github.com/stephenmcd/grappelli-safe";
    downloadPage = "http://pypi.python.org/pypi/grappelli_safe/";
    license = licenses.free;
    maintainers = with maintainers; [ prikhi ];
    platforms = platforms.unix;
  };

}

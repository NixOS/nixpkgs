{ lib
, buildPythonPackage
, fetchPypi
, django
}:

buildPythonPackage rec {
  version = "1.1.1";
  pname = "filebrowser_safe";

  src = fetchPypi {
    inherit pname version;
    sha256 = "499c5dbd9e112dfc436cae7713b2fb664a59015021f6c9d131e3b7980aeb5c94";
  };

  buildInputs = [ django ];

  # There is no test embedded
  doCheck = false;

  meta = with lib; {
    description = "A snapshot of django-filebrowser for the Mezzanine CMS";
    longDescription = ''
      filebrowser_safe was created to provide a snapshot of the
      FileBrowser asset manager for Django, to be referenced as a
      dependency for the Mezzanine CMS for Django.

      At the time of filebrowser_safe's creation, FileBrowser was
      incorrectly packaged on PyPI, and had also dropped compatibility
      with Django 1.1 - filebrowser_safe was therefore created to
      address these specific issues.
    '';
    homepage = "https://github.com/stephenmcd/filebrowser-safe";
    downloadPage = "https://pypi.python.org/pypi/filebrowser_safe/";
    license = licenses.free;
    maintainers = with maintainers; [ prikhi ];
    platforms = platforms.unix;
  };

}

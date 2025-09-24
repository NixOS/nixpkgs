{
  lib,
  buildPythonPackage,
  fetchPypi,
  django,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "filebrowser-safe";
  version = "1.1.1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    pname = "filebrowser_safe";
    inherit version;
    sha256 = "499c5dbd9e112dfc436cae7713b2fb664a59015021f6c9d131e3b7980aeb5c94";
  };

  buildInputs = [ django ];

  # There is no test embedded
  doCheck = false;

  meta = with lib; {
    description = "Snapshot of django-filebrowser for the Mezzanine CMS";
    longDescription = ''
      filebrowser-safe was created to provide a snapshot of the
      FileBrowser asset manager for Django, to be referenced as a
      dependency for the Mezzanine CMS for Django.
    '';
    homepage = "https://github.com/stephenmcd/filebrowser-safe";
    downloadPage = "https://pypi.python.org/pypi/filebrowser_safe/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ prikhi ];
    platforms = platforms.unix;
  };
}

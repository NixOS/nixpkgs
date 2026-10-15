{
  lib,
  buildPythonPackage,
  fetchPypi,
  django,
}:

buildPythonPackage rec {
  pname = "filebrowser-safe";
  version = "1.1.1";
  format = "setuptools";

  src = fetchPypi {
    pname = "filebrowser_safe";
    inherit version;
    hash = "sha256-SZxdvZ4RLfxDbK53E7L7ZkpZAVAh9snRMeO3mArrXJQ=";
  };

  buildInputs = [ django ];

  # There is no test embedded
  doCheck = false;

  meta = {
    description = "Snapshot of django-filebrowser for the Mezzanine CMS";
    longDescription = ''
      filebrowser-safe was created to provide a snapshot of the
      FileBrowser asset manager for Django, to be referenced as a
      dependency for the Mezzanine CMS for Django.
    '';
    homepage = "https://github.com/stephenmcd/filebrowser-safe";
    downloadPage = "https://pypi.org/project/filebrowser_safe/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ prikhi ];
    platforms = lib.platforms.unix;
  };
}

{ lib
, buildPythonPackage
, fetchFromGitHub
, isPy3k
, gipc
, greenlet
, httplib2
, six
, python-dateutil
, fusepy
, google-api-python-client
}:

buildPythonPackage rec {
  version = "0.14.12";
  pname = "gdrivefs";
  disabled = isPy3k;

  src = fetchFromGitHub {
    owner = "dsoprea";
    repo = "GDriveFS";
    rev = version;
    sha256 = "sha256-eDBy2rp3uitUrR9CG75x8mAio8+gaSckA/lEPAWO0Yo=";
  };

  buildInputs = [ gipc greenlet httplib2 six ];
  propagatedBuildInputs = [ python-dateutil fusepy google-api-python-client ];

  patchPhase = ''
    substituteInPlace gdrivefs/resources/requirements.txt \
      --replace "==" ">="
  '';

  meta = with lib; {
    description = "Mount Google Drive as a local file system";
    longDescription = ''
      GDriveFS is a FUSE wrapper for Google Drive developed. Design goals:
      - Thread for monitoring changes via "changes" functionality of API.
      - Complete stat() implementation.
      - Seamlessly work around duplicate-file allowances in Google Drive.
      - Seamlessly manage file-type versatility in Google Drive
        (Google Doc files do not have a particular format).
      - Allow for the same file at multiple paths.
    '';
    homepage = "https://github.com/dsoprea/GDriveFS";
    license = licenses.gpl2;
    platforms = platforms.unix;
  };

}

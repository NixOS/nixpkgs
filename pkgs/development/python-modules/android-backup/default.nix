{ lib
, buildPythonPackage
, fetchFromGitHub
, pycrypto
, pythonOlder
, enum34
, python
}:

buildPythonPackage rec {
  pname = "android-backup";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "bluec0re";
    repo = "android-backup-tools";
    rev = "v${version}";
    sha256 = "0c436hv64ddqrjs77pa7z6spiv49pjflbmgg31p38haj5mzlrqvw";
  };

  propagatedBuildInputs = [
    pycrypto
  ] ++ lib.optional (pythonOlder "3.4") enum34;

  checkPhase = ''
    ${python.interpreter} -m android_backup.tests
  '';

  pythonImportsCheck = [ "android_backup" ];

  meta = with lib; {
    description = "Unpack and repack android backups";
    homepage = https://github.com/bluec0re/android-backup-tools;
    license = licenses.asl20;
    maintainers = with maintainers; [ dotlambda ];
  };
}

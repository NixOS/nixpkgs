{ lib, buildPythonPackage, fetchPypi, isPy3k, alsaUtils, libnotify, which, loguru, pytest }:

buildPythonPackage rec {
  pname = "notify_py";
  version = "0.2.4";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "2a19273a476c8b003baa96650d00a81c5981c3a17ada748bc0a73aefad46d977";
  };

  postPatch = ''
   substituteInPlace setup.py \
     --replace "loguru==0.4.1" "loguru~=0.5.0"
  '';

  propagatedBuildInputs = [ alsaUtils libnotify loguru which ];

  checkInputs = [ alsaUtils libnotify pytest which ];

  checkPhase = ''
    pytest
  '';

  pythonImportsCheck = [ "notifypy" ];

  meta = with lib; {
    description = " Python Module for sending cross-platform desktop notifications on Windows, macOS, and Linux.";
    homepage = "https://github.com/ms7m/notify-py/";
    license = licenses.mit;
    maintainers = with maintainers; [ austinbutler ];
  };
}

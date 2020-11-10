{ lib, buildPythonPackage, fetchPypi, isPy3k, alsaUtils, libnotify, which, loguru, pytest }:

buildPythonPackage rec {
  pname = "notify_py";
  version = "0.2.3";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1i209xsff54hipdk9cg6va60fl33swg126yfgkg3wsgjmi6s07ca";
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

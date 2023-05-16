{ lib
, buildPythonPackage
, fetchPypi
, numpy
, pyyaml
, python-dateutil
, urllib3
, tqdm
, dnspython
, requests
, typing-extensions
, loguru
}:
buildPythonPackage rec {
  pname = "pinecone-client";
<<<<<<< HEAD
  version = "2.2.2";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-OR/kE3VO/U4O8AFUtEJx1jxM3Uvt8IjSMRGlcl2GMhA=";
=======
  version = "2.2.1";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-CHjcruRHxGyNGz1xyFRonap+VI5QCaFxeAkHx9TnR4k=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    numpy
    pyyaml
    python-dateutil
    urllib3
    tqdm
    dnspython
    requests
    typing-extensions
    loguru
  ];

  doCheck = false;

  meta = with lib; {
    homepage = "https://www.pinecone.io/";
    description = "The Pinecone python client";
    license = licenses.mit;
    maintainers = with maintainers; [happysalada];
  };
}

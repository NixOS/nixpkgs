{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pythonOlder
, absl-py
, google-api-python-client
, oauth2client
}:

buildPythonPackage rec {
  pname = "cloud-tpu-client";
  version = "0.10";
  format = "wheel";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    pname = builtins.replaceStrings ["-"] ["_"] pname;
    inherit version format;
    dist = "py3";
    python = "py3";
    hash = "sha256-4+56CmnD/b/IKCbYZ2LyTkO/zWCWrwRxhXCP4GLH+Ek=";
  };

  propagatedBuildInputs = [
    absl-py
    google-api-python-client
    oauth2client
  ];

  pythonImportsCheck = [
    "cloud_tpu_client"
  ];

  meta = with lib; {
    description = "Client for using Cloud TPUs";
    homepage = "https://cloud.google.com/tpu/";
    license = licenses.asl20;
    maintainers = [ maintainers.gbpdt ];
  };
}

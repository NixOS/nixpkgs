{ lib
, betamax
, buildPythonPackage
<<<<<<< HEAD
, fetchPypi
, pyopenssl
, pytestCheckHook
, requests
, trustme
=======
, fetchpatch
, fetchPypi
, mock
, pyopenssl
, pytestCheckHook
, requests
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "requests-toolbelt";
<<<<<<< HEAD
  version = "1.0.0";
=======
  version = "0.10.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-doGgo9BHAStb3A7jfX+PB+vnarCMrsz8OSHOI8iNW8Y=";
=======
    hash = "sha256-YuCff/XMvakncqKfOUpJw61ssYHVaLEzdiayq7Yopj0=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    requests
  ];

  nativeCheckInputs = [
    betamax
<<<<<<< HEAD
    pyopenssl
    pytestCheckHook
    trustme
=======
    mock
    pytestCheckHook
  ];

  disabledTests = [
    # https://github.com/requests/toolbelt/issues/306
    "test_no_content_length_header"
    "test_read_file"
    "test_reads_file_from_url_wrapper"
    "test_x509_der"
    "test_x509_pem"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  pythonImportsCheck = [
    "requests_toolbelt"
  ];

  meta = with lib; {
    description = "Toolbelt of useful classes and functions to be used with requests";
    homepage = "http://toolbelt.rtfd.org";
<<<<<<< HEAD
    changelog = "https://github.com/requests/toolbelt/blob/${version}/HISTORY.rst";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.asl20;
    maintainers = with maintainers; [ matthiasbeyer ];
  };
}

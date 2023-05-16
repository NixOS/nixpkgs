{ lib
, buildPythonPackage
, fetchFromGitHub
, fpyutils
, pyfakefs
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "md-toc";
<<<<<<< HEAD
  version = "8.2.0";
=======
  version = "8.1.9";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "frnmst";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    hash = "sha256-7Udmon/5E741+v2vBHHL7h31r91RR33hN1WhL3FiDQc=";
=======
    hash = "sha256-t3G8nQCVUUuDb+W+Gw+f2miXQ2i/hdVfT6yGxdNWKpw=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    fpyutils
  ];

  nativeCheckInputs = [
    pyfakefs
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "md_toc/tests/*.py"
  ];

  pythonImportsCheck = [
    "md_toc"
  ];

  meta = with lib; {
    description = "Table of contents generator for Markdown";
    homepage = "https://docs.franco.net.eu.org/md-toc/";
    changelog = "https://blog.franco.net.eu.org/software/CHANGELOG-md-toc.html";
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ fab ];
  };
}

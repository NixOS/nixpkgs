{ lib
, buildPythonPackage
, fetchFromGitHub
, inotify-simple
}:

buildPythonPackage rec {
  pname = "inotifyrecursive";
  version = "0.3.5";

  src = fetchFromGitHub {
     owner = "letorbi";
     repo = "inotifyrecursive";
     rev = "0.3.5";
     sha256 = "16kdww3iqpgqcn5za687shbijbvi5f38qrsh5wklyhf6r77llsh4";
  };

  propagatedBuildInputs = [ inotify-simple ];

  # No tests included
  doCheck = false;
  pythonImportsCheck = [ pname ];

  meta = with lib; {
    description = "Simple recursive inotify watches for Python";
    homepage = "https://github.com/letorbi/inotifyrecursive";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ Flakebi ];
  };
}

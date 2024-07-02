{ lib
, pkgs
, python3Packages
, fetchPypi
, poetry-core
}:

python3Packages.buildPythonPackage rec {
  pname = "realtime";
  version = "1.0.3";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Gjm13Ns0W0zH/UO8A1/rOMqRXJJIli8g0mRiW8jrLE4=";
  };

  propagatedBuildInputs = with python3Packages; [
    python-dateutil
    typing-extensions
    websockets
  ];

  nativeBuildInputs = with python3Packages; [
    poetry-core
  ];


  # tests are not in pypi package
  doCheck = false;


  meta = with lib; {
    homepage = "https://github.com/supabase-community/auth-py";
    license = licenses.mit;
    description = "Python Realtime Client for Supabase";
    mainProgram = "realtime";
    maintainers = with maintainers; [ samrose ];
  };
}

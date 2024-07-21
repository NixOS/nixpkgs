{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flask,
}:

buildPythonPackage rec {
  pname = "flask-versioned";
  version = "0.9.4-20101221";

  src = fetchFromGitHub {
    owner = "pilt";
    repo = "flask-versioned";
    rev = "38046fb53a09060de437c90a5f7370a6b94ffc31"; # no tags
    sha256 = "1wim9hvx7lxzfg35c0nc7p34j4vw9mzisgijlz4ibgykah4g1y37";
  };

  propagatedBuildInputs = [ flask ];

  meta = with lib; {
    description = "Flask plugin to rewrite file paths to add version info";
    homepage = "https://github.com/pilt/flask-versioned";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}

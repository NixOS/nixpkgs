{ lib
, buildPythonPackage
, fetchFromGitHub
, isPy3k
, pyparsing
}:

buildPythonPackage {
  pname = "mutag";
  version = "0.0.2-2ffa0258ca";
  disabled = ! isPy3k;

  src = fetchFromGitHub {
    owner = "aroig";
    repo = "mutag";
    rev = "2ffa0258cadaf79313241f43bf2c1caaf197d9c2";
    sha256 = "sha256-YT3DGvYPyTuB70gg6p/3oXcTahEPcNuSIqe56xu3rSs=";
  };

  propagatedBuildInputs = [ pyparsing ];

  meta = with lib; {
    homepage = "https://github.com/aroig/mutag";
    description = "A script to change email tags in a mu indexed maildir";
    license = licenses.gpl3;
    maintainers = with maintainers; [ ];
  };

}

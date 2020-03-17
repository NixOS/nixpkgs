{ stdenv
, fetchFromGitHub
, buildPythonPackage
, isPy3k
, greenlet
}:

buildPythonPackage rec {
  pname = "python-eventlib";
  version = "0.2.5";
  # Judging from SyntaxError
  disabled = isPy3k;

  src = fetchFromGitHub {
    owner = "AGProjects";
    repo = pname;
    rev = "release-${version}";
    hash = "sha256-ZTQfar6Jf0pRQVR6OXR77Em8a4y2qsTu7ZZ1+EZfvEQ=";
  };

  propagatedBuildInputs = [ greenlet ];

  doCheck = false;

  meta = with stdenv.lib; {
    description = "Eventlib bindings for python";
    homepage    = "https://ag-projects.com/";
    license     = licenses.lgpl2;
  };

}

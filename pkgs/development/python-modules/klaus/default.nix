{ lib, buildPythonPackage, fetchFromGitHub, isPy3k, six, flask, pygments, dulwich, httpauth, humanize, pytest, requests, python-ctags3, mock }:

buildPythonPackage rec {
  pname = "klaus";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "jonashaag";
    repo = pname;
    rev = version;
    sha256 = "1432m3ki2g4ma10pfv310q1w4da46b0y2jklb8ajbz8a09ms6mfx";
  };

  prePatch = ''
    substituteInPlace runtests.sh \
      --replace "mkdir -p \$builddir" "mkdir -p \$builddir && pwd"
  '';

  propagatedBuildInputs = [
    six flask pygments dulwich httpauth humanize
  ];

  checkInputs = [
    pytest requests python-ctags3
  ] ++ lib.optional (!isPy3k) mock;

  checkPhase = ''
    ./runtests.sh
  '';

  # Needs to set up some git repos
  doCheck = false;

  meta = with lib; {
    description = "The first Git web viewer that Just Works";
    homepage    = https://github.com/jonashaag/klaus;
    license     = licenses.isc;
    maintainers = with maintainers; [ pSub ];
  };
}

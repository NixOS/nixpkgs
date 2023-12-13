{ lib, buildPythonPackage, fetchFromGitHub, isPy3k, flask, pygments, dulwich, httpauth, humanize, pytest, requests, python-ctags3, mock }:

buildPythonPackage rec {
  pname = "klaus";
  version = "2.0.3";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "jonashaag";
    repo = pname;
    rev = version;
    hash = "sha256-VAwIdmwdo/Rim2sVlR605Wo5/zkNOMiGkh40qLrENmU=";
  };

  prePatch = ''
    substituteInPlace runtests.sh \
      --replace "mkdir -p \$builddir" "mkdir -p \$builddir && pwd"
  '';

  propagatedBuildInputs = [
    flask pygments dulwich httpauth humanize
  ];

  nativeCheckInputs = [
    pytest requests python-ctags3
  ] ++ lib.optional (!isPy3k) mock;

  checkPhase = ''
    ./runtests.sh
  '';

  # Needs to set up some git repos
  doCheck = false;

  meta = with lib; {
    description = "The first Git web viewer that Just Works";
    homepage    = "https://github.com/jonashaag/klaus";
    license     = licenses.isc;
    maintainers = with maintainers; [ pSub ];
  };
}

{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  isPy3k,
  flask,
  pygments,
  dulwich,
  httpauth,
  humanize,
  pytest,
  requests,
  python-ctags3,
  mock,
}:

buildPythonPackage rec {
  pname = "klaus";
  version = "3.0.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "jonashaag";
    repo = pname;
    rev = version;
    hash = "sha256-GflSDhBmMsQ34o3ApraEJ6GmlXXP2kK6WW3lsfr6b7g=";
  };

  prePatch = ''
    substituteInPlace runtests.sh \
      --replace "mkdir -p \$builddir" "mkdir -p \$builddir && pwd"
  '';

  propagatedBuildInputs = [
    flask
    pygments
    dulwich
    httpauth
    humanize
  ];

  nativeCheckInputs = [
    pytest
    requests
    python-ctags3
  ] ++ lib.optional (!isPy3k) mock;

  checkPhase = ''
    ./runtests.sh
  '';

  # Needs to set up some git repos
  doCheck = false;

  meta = with lib; {
    description = "First Git web viewer that Just Works";
    mainProgram = "klaus";
    homepage = "https://github.com/jonashaag/klaus";
    license = licenses.isc;
    maintainers = with maintainers; [ pSub ];
  };
}

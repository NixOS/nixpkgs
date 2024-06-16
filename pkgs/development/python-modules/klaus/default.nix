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
  version = "3.0.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "jonashaag";
    repo = pname;
    rev = version;
    hash = "sha256-BcLlvZ9Ip3laL0cLkqK+mhB+S7ubB4TuZ0VKXOOX3oA=";
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
    description = "The first Git web viewer that Just Works";
    mainProgram = "klaus";
    homepage = "https://github.com/jonashaag/klaus";
    license = licenses.isc;
    maintainers = with maintainers; [ pSub ];
  };
}

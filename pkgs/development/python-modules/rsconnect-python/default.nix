{ lib
, stdenv
, buildPythonPackage
, pythonOlder
, fetchFromGitHub

# setup requirements
, setuptools
, setuptools_scm
, toml
, wheel

# install requirements
, six
, click
, pip
, semver
, pyjwt

# check requirements
, pytest
, httpretty
, nbconvert
, ipykernel
}:

buildPythonPackage rec {
  pname = "rsconnect-python";
  version = "1.16.0";
  format = "pyproject";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "rstudio";
    repo = "rsconnect-python";
    rev = "${version}";
    hash = "sha256-DWfr2baGfAp6CdDS/cCinG12XBGoViwEFkxW8zPT86Q=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  postPatch = ''
    substituteInPlace setup.py --replace 'semver>=2.0.0,<3.0.0' 'semver>=2.0.0'
  '';

  nativeBuildInputs = [
    setuptools
    setuptools_scm
    toml
    wheel
  ];

  propagatedBuildInputs = [
    six
    click
    pip
    semver
    pyjwt
  ];

  nativeCheckInputs = [
    pytest
    httpretty
    nbconvert
    ipykernel
  ];

  checkPhase = ''
    runHook preCheck
    # Needed to avoid /homeless-shelter error
    export HOME=$(mktemp -d)
    pytest tests/
    runHook postCheck
  '';

  doCheck = true;

  pythonImportsCheck = [ "rsconnect" ];

  meta = with lib; {
    homepage = "https://docs.posit.co/rsconnect-python";
    description = "The rsconnect-python CLI";
    license = licenses.gpl2;
    maintainers = with maintainers; [ nviets ];
    platforms = platforms.unix;
  };
}


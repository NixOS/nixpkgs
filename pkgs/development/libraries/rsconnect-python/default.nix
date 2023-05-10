{ lib
, stdenv
, python3Packages
, fetchFromGitHub
, python
}:

python3Packages.buildPythonApplication rec {
  pname = "rsconnect-python";
  version = "1.16.0";
  format = "pyproject";
  disabled = python3Packages.pythonOlder "3.7";

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

  nativeBuildInputs = with python3Packages; [
    setuptools
    setuptools_scm
    toml
    wheel
  ];

  propagatedBuildInputs = with python3Packages; [
    six
    click
    pip
    semver
    pyjwt
  ];

  nativeCheckInputs = with python3Packages; [
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

  meta = with lib; {
    homepage = "https://docs.posit.co/rsconnect-python";
    description = "The rsconnect-python CLI";
    license = licenses.gpl2;
    maintainers = with maintainers; [ nviets ];
    platforms = platforms.unix;
  };
}

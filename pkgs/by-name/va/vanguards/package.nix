{
  python312Packages,
  fetchFromGitHub,
  lib,
}:
python312Packages.buildPythonApplication {
  pname = "vanguards";
  version = "0.3.1";
  pyproject = true;

  build-system = [ python312Packages.setuptools ];

  dependencies = [ python312Packages.stem ];
  #tries to access the network during the tests, which fails
  doCheck = false;

  src = fetchFromGitHub {
    owner = "mikeperry-tor";
    repo = "vanguards";
    rev = "8132fa0e556fbcbb3538ff9b48a2180c0c5e8fbd";
    sha256 = "sha256-XauSTgoH6zXv2DXyX2lQc6gy6Ysm41fKnyuWZ3hj7kI=";
  };
  patches = [ ./python-3.12.patch ];
  postPatch = ''
    # fix import cycle issue
    substituteInPlace src/vanguards/main.py --replace-fail \
      'import stem.response.events' 'import stem.socket; import stem.control; import stem.response.events'
  '';

  pythonImportsCheck = [ "vanguards" ];

  meta = {
    maintainers = with lib.maintainers; [ ForgottenBeast ];
    mainProgram = "vanguards";
    license = lib.licenses.mit;
    homepage = "https://github.com/mikeperry-tor/vanguards";
    description = "Protects TOR hidden services against guard node attacks";
    longDescription = ''
      Runs alongside tor and interacts with its control port
      in order to protect and alert against guard node attacks on hidden services
    '';
  };
}

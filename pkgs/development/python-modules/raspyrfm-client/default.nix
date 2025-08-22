{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "raspyrfm-client";
  version = "1.2.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "markusressel";
    repo = "raspyrfm-client";
    tag = "v${version}";
    hash = "sha256-WiL69bb4h8xVdMYxAVU0NHEfTWyW2NVR86zigsr5dmk=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail 'subprocess.check_output(["git", "rev-parse", "--abbrev-ref", "HEAD"])' "'master'" \
      --replace-fail 'GIT_BRANCH = GIT_BRANCH.decode()' ""
  '';

  build-system = [ setuptools ];

  # Tests require hardware
  doCheck = false;

  pythonImportsCheck = [ "raspyrfm_client" ];

  meta = {
    description = "Library to send rc signals with the RaspyRFM module";
    homepage = "https://github.com/markusressel/raspyrfm-client";
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
}

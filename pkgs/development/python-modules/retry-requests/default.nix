{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  # dependencies
  urllib3,
  requests,
}:

buildPythonPackage (finalAttrs: {
  pname = "retry-requests";
  version = "2.0.0-unstable-2023-05-28";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bustawin";
    repo = "retry-requests";
    rev = "543ceaf451df8268717eb929372439a4e48cff66";
    hash = "sha256-MbvxHH+fdB4JGLEuZ5SclBUrw04JxzR5zdX/EyaMEnU=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail 'setup_requires=["pytest-runner"],' ""
  '';

  build-system = [ setuptools ];

  dependencies = [
    requests
    urllib3
  ];

  pythonImportsCheck = [ "retry_requests" ];

  meta = {
    description = "A Python library that makes HTTP requests with retry by using requests package";
    homepage = "https://github.com/bustawin/retry-requests";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ robertjakub ];
  };
})

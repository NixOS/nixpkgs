{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  stdenv,
}:

buildPythonPackage rec {
  pname = "cv2_enumerate_cameras";
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "lukehugh";
    repo = "cv2_enumerate_cameras";
    tag = "v${version}";
    hash = "sha256-wBjpZxqzWYXWlgcqJmpohJFK97Eh1IkWtNn6S6DlWPo=";
  };

  pyproject = true;
  build-system = [ setuptools ];

  pythonImportsCheck = [ "cv2_enumerate_cameras" ];

  meta = {
    homepage = "https://github.com/lukehugh/cv2_enumerate_cameras";
    description = "Retrieve the connected camera's name, VID, PID, and the corresponding OpenCV index";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.qyliss ];
    # Needs pyobjc-framework-avfoundation; not currently packaged.
    broken = stdenv.hostPlatform.isDarwin;
  };
}

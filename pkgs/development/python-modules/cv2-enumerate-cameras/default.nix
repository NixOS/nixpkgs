{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  stdenv,
}:

buildPythonPackage rec {
  pname = "cv2_enumerate_cameras";
<<<<<<< HEAD
  version = "1.3.1";
=======
  version = "1.3.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "lukehugh";
    repo = "cv2_enumerate_cameras";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-iaSOjVJzRDPqjDaGF2q37JB2iJLc+nVP7F9eTbOq3l8=";
=======
    hash = "sha256-pIqT5GEEyRIVHjWd9nNSI4oEvsPjOe2mPC3GWxEdonw=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

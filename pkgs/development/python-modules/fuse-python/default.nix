{
  stdenv,
  lib,
  buildPythonPackage,
  fetchPypi,
  pkg-config,
  setuptools,
  fuse,
}:

buildPythonPackage rec {
  pname = "fuse-python";
  version = "1.0.9";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "fuse_python";
    hash = "sha256-ntWVd8NqshjXAKooOfAh8SwlKzVxhgV1crmOGbwqhYk=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail 'pkg-config' "${stdenv.cc.targetPrefix}pkg-config"
  '';

  nativeBuildInputs = [ pkg-config ];

  build-system = [ setuptools ];

  buildInputs = [ fuse ];

  # no tests implemented
  doCheck = false;

  pythonImportsCheck = [ "fuse" ];

<<<<<<< HEAD
  meta = {
    broken = stdenv.hostPlatform.isDarwin;
    description = "Python bindings for FUSE";
    homepage = "https://github.com/libfuse/python-fuse";
    license = lib.licenses.lgpl21;
    maintainers = with lib.maintainers; [ psyanticy ];
=======
  meta = with lib; {
    broken = stdenv.hostPlatform.isDarwin;
    description = "Python bindings for FUSE";
    homepage = "https://github.com/libfuse/python-fuse";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ psyanticy ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}

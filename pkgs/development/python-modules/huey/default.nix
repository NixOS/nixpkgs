{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  wheel,
  redis,
}:

buildPythonPackage rec {
  pname = "huey";
<<<<<<< HEAD
  version = "2.5.5";
=======
  version = "2.5.4";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  format = "pyproject";

  src = fetchFromGitHub {
    owner = "coleifer";
    repo = "huey";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-fpnaf0hk26Sm+d3pggW/GfT0oSbYpSm5xotejbOWeJY=";
=======
    hash = "sha256-PIMnPb6QQh20/LPfk8LaidhLHMrL8dHigLigyy2ki4Q=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [ redis ];

  # connects to redis
  doCheck = false;

<<<<<<< HEAD
  meta = {
    changelog = "https://github.com/coleifer/huey/blob/${src.tag}/CHANGELOG.md";
    description = "Little task queue for python";
    homepage = "https://github.com/coleifer/huey";
    license = lib.licenses.mit;
=======
  meta = with lib; {
    changelog = "https://github.com/coleifer/huey/blob/${src.tag}/CHANGELOG.md";
    description = "Little task queue for python";
    homepage = "https://github.com/coleifer/huey";
    license = licenses.mit;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
  };
}

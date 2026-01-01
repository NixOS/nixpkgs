{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  requests,
}:

buildPythonPackage rec {
  pname = "kivy-garden";
  version = "0.1.5";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "kivy-garden";
    repo = "garden";
    rev = "v${version}";
    hash = "sha256-xOMBPFKV7mTa51Q0VKja7b0E509IaWjwlJVlSRVdct8=";
  };

  propagatedBuildInputs = [ requests ];

  pythonImportsCheck = [ "garden" ];

  # There are no tests
  doCheck = false;

<<<<<<< HEAD
  meta = {
    description = "Kivy garden installation script, split into its own package for convenient use in buildozer";
    homepage = "https://github.com/kivy-garden/garden";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ risson ];
=======
  meta = with lib; {
    description = "Kivy garden installation script, split into its own package for convenient use in buildozer";
    homepage = "https://github.com/kivy-garden/garden";
    license = licenses.mit;
    maintainers = with maintainers; [ risson ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}

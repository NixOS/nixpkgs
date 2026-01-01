{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pytest-cov-stub,
}:

buildPythonPackage rec {
  pname = "ratelimit";
  version = "2.2.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "tomasbasham";
    repo = "ratelimit";
    rev = "v${version}";
    sha256 = "04hy3hhh5xdqcsz0lx8j18zbj88kh5ik4wyi5d3a5sfy2hx70in2";
  };

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
  ];

  enabledTestPaths = [ "tests" ];

  pythonImportsCheck = [ "ratelimit" ];

<<<<<<< HEAD
  meta = {
    description = "Python API Rate Limit Decorator";
    homepage = "https://github.com/tomasbasham/ratelimit";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
=======
  meta = with lib; {
    description = "Python API Rate Limit Decorator";
    homepage = "https://github.com/tomasbasham/ratelimit";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}

{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
<<<<<<< HEAD
  uv-build,
=======
  setuptools,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  # dependencies
  pytest,

  # tests
<<<<<<< HEAD
  pytestCheckHook,
=======
  pytest7CheckHook,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

let
  pname = "pytest-describe";
<<<<<<< HEAD
  version = "3.0.0";
=======
  version = "2.2.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
in
buildPythonPackage {
  inherit pname version;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pytest-dev";
    repo = "pytest-describe";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-rMO+Hkz3iWFML8UUq4aDl+t7epzqXmYGZrgRB9OYf6w=";
  };

  build-system = [ uv-build ];

  buildInputs = [ pytest ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Describe-style plugin for the pytest framework";
    homepage = "https://github.com/pytest-dev/pytest-describe";
    changelog = "https://github.com/pytest-dev/pytest-describe/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hexa ];
=======
    hash = "sha256-ih0XkYOtB+gwUsgo1oSti2460P3gq3tR+UsyRlzMjLE=";
  };

  build-system = [ setuptools ];

  buildInputs = [ pytest ];

  # test_fixture breaks with pytest 8.4
  nativeCheckInputs = [ pytest7CheckHook ];

  meta = with lib; {
    description = "Describe-style plugin for the pytest framework";
    homepage = "https://github.com/pytest-dev/pytest-describe";
    changelog = "https://github.com/pytest-dev/pytest-describe/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}

{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pytest
, pudb
}:

buildPythonPackage rec {
  pname = "pytest-pudb";
  version = "0.7.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "wronglink";
    repo = "pytest-pudb";
    # Repo missing tags for releases https://github.com/wronglink/pytest-pudb/issues/24
    rev = "a6b3d2f4d35e558d72bccff472ecde9c9d9c69e5";
    hash = "sha256-gI9p6sXCQaQjWBXaHJCFli6lBh8+pr+KPhz50fv1F7A=";
  };

  buildInputs = [ pytest ];

  propagatedBuildInputs = [ pudb ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pytest_pudb" ];

  meta = with lib; {
    description = "Pytest PuDB debugger integration";
    homepage = "https://github.com/wronglink/pytest-pudb";
    license = licenses.mit;
    maintainers = with maintainers; [ thornycrackers ];
  };
}

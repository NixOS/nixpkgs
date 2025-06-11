{
  lib,
  pythonOlder,
  pytestCheckHook,
  pytest-cov-stub,
  hatchling,
  fetchFromGitHub,
  buildPythonPackage,
}:

buildPythonPackage rec {
  pname = "entry-points-txt";
  version = "0.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jwodder";
    repo = "entry-points-txt";
    tag = "v${version}";
    hash = "sha256-hIUXxBJ0XSB4FrNZJdofJ1gTTncILNq9Xh+iAV1CD0s=";
  };

  nativeBuildInputs = [ hatchling ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
  ];

  pythonImportsCheck = [ "entry_points_txt" ];

  meta = with lib; {
    description = "Read & write entry_points.txt files";
    homepage = "https://github.com/jwodder/entry-points-txt";
    changelog = "https://github.com/wheelodex/entry-points-txt/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ ayazhafiz ];
  };
}

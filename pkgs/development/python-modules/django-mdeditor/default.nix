{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  django,
}:
let
  version = "0.1.20";
in
buildPythonPackage {
  pname = "django-mdeditor";
  inherit version;

  src = fetchFromGitHub {
    owner = "pylixm";
    repo = "django-mdeditor";
    rev = "v${version}";
    hash = "sha256-t57j1HhjNQtBwlbqe4mAHQ9WiNcIhMKYmrZkiqh+k5k=";
  };

  patches = [
    (fetchpatch {
      name = "Replace-bootcdn-with-jsdelivr.patch";
      url = "https://github.com/pylixm/django-mdeditor/pull/184/commits/43c2ae8024ce359e34009faaf813568be8fbbdad.patch";
      hash = "sha256-9ThEDHOrXqZrupo7CKEYiDILgunqz5fXH37olanJo6A=";
    })
  ];

  propagatedBuildInputs = [ django ];

  # no tests
  doCheck = false;
  pythonImportsCheck = [ "mdeditor" ];

  meta = with lib; {
    description = "Markdown Editor plugin application for django based on Editor.md";
    homepage = "https://github.com/pylixm/django-mdeditor";
    changelog = "https://github.com/pylixm/django-mdeditor/releases";
    license = licenses.gpl3;
    maintainers = with maintainers; [ augustebaum ];
  };
}

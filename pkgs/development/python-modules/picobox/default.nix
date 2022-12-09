{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, flask
, isPy27
, pytestCheckHook
, pythonAtLeast
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "picobox";
  version = "2.2.0";

  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "ikalnytskyi";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-B2A8GMhBFU/mb/JiiqtP+HvpPj5FYwaYO3gQN2QI6z0=";
  };

  patches = [
    (fetchpatch {
      # already in master, but no new release yet.
      # https://github.com/ikalnytskyi/picobox/issues/55
      url = "https://github.com/ikalnytskyi/picobox/commit/1fcc4a0c26a7cd50ee3ef6694139177b5dfb2be0.patch";
      hash = "sha256-/NIEzTFlZ5wG7jHT/YdySYoxT/UhSk29Up9/VqjG/jg=";
      includes = [
        "tests/test_box.py"
        "tests/test_stack.py"
      ];
    })
  ];

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools-scm
  ];

  checkInputs = [
    flask
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "picobox"
  ];

  meta = with lib; {
    description = "Opinionated dependency injection framework";
    homepage = "https://github.com/ikalnytskyi/picobox";
    license = licenses.mit;
    maintainers = with maintainers; [ flokli ];
  };
}

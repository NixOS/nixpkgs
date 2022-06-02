{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, setuptools
, setuptools-scm
, pyvcd
, jinja2
, importlib-resources
, importlib-metadata
, git

# for tests
, pytestCheckHook
, symbiyosys
, yices
, yosys
}:

buildPythonPackage rec {
  pname = "amaranth";
  version = "0.3";
  # python setup.py --version
  realVersion = "0.3";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "amaranth-lang";
    repo = "amaranth";
    rev = "39a83f4d995d16364cc9b99da646ff8db6394166";
    sha256 = "P9AG3t30eGeeCN5+t7mjhRoOWIGZVzWQji9eYXphjA0=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION="${realVersion}";

  nativeBuildInputs = [
    git
    setuptools-scm
  ];

  propagatedBuildInputs = [
    jinja2
    pyvcd
    setuptools
  ] ++
    lib.optional (pythonOlder "3.9") importlib-resources ++
    lib.optional (pythonOlder "3.8") importlib-metadata;

  checkInputs = [
    pytestCheckHook
    symbiyosys
    yices
    yosys
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "Jinja2~=2.11" "Jinja2>=2.11" \
      --replace "pyvcd~=0.2.2" "pyvcd"

    # jinja2.contextfunction was removed in jinja2 v3.1
    substituteInPlace amaranth/build/plat.py \
      --replace "@jinja2.contextfunction" "@jinja2.pass_context"
  '';

  pythonImportsCheck = [ "amaranth" ];

  meta = with lib; {
    description = "A modern hardware definition language and toolchain based on Python";
    homepage = "https://amaranth-lang.org/docs/amaranth";
    license = licenses.bsd2;
    maintainers = with maintainers; [ emily thoughtpolice ];
  };
}

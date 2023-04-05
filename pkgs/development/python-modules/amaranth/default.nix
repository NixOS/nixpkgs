{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, fetchpatch
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

  patches = [
    (fetchpatch {
      name = "fix-for-setuptools-64.0.2-preparation.patch";
      url = "https://github.com/amaranth-lang/amaranth/commit/64771a065a280fa683c1e6692383bec4f59f20fa.patch";
      hash = "sha256-Rsh9vVvUQj9nIcrsRirmR6XwFrfZ2VMaYJ4RCQ8sBE0=";
      # This commit removes support for Python 3.6, which is unnecessary to fix
      # the build when using new setuptools. Include only one file, which has a
      # harmless comment change so that the subsequent patch applies cleanly.
      includes = ["amaranth/_toolchain/cxx.py"];
    })
    (fetchpatch {
      name = "fix-for-setuptools-64.0.2.patch";
      url = "https://github.com/amaranth-lang/amaranth/pull/722/commits/e5a56b07c568e5f4cc2603eefebd14c5cc4e13d8.patch";
      hash = "sha256-C8FyMSKHA7XsEMpO9eYNZx/X5rGaK7p3eXP+jSb6wVg=";
    })
    (fetchpatch {
      name = "add-python-3.11-support.patch";
      url = "https://github.com/amaranth-lang/amaranth/commit/851546bf2d16db62663d7002bece51f07078d0a5.patch";
      hash = "sha256-eetlFCLqmpCfTKViD16OScJbkql1yhdi5uJGnfnpcCE=";
    })
  ];

  SETUPTOOLS_SCM_PRETEND_VERSION="${realVersion}";

  nativeBuildInputs = [
    git
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
    jinja2
    pyvcd
    setuptools
  ] ++
    lib.optional (pythonOlder "3.9") importlib-resources ++
    lib.optional (pythonOlder "3.8") importlib-metadata;

  nativeCheckInputs = [
    pytestCheckHook
    symbiyosys
    yices
    yosys
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "Jinja2~=2.11" "Jinja2>=2.11" \
      --replace "pyvcd~=0.2.2" "pyvcd" \
      --replace "amaranth-yosys>=0.10.*" "amaranth-yosys>=0.10"

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

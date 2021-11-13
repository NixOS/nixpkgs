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
  pname = "nmigen";
  version = "unstable-2021-02-09";
  # python setup.py --version
  realVersion = "0.3.dev243+g${lib.substring 0 7 src.rev}";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "nmigen";
    repo = "nmigen";
    rev = "f7c2b9419f9de450be76a0e9cf681931295df65f";
    sha256 = "0cjs9wgmxa76xqmjhsw4fsb2mhgvd85jgs2mrjxqp6fwp8rlgnl1";
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
  '';

  pythonImportsCheck = [ "nmigen" ];

  meta = with lib; {
    description = "A refreshed Python toolbox for building complex digital hardware";
    homepage = "https://nmigen.info/nmigen";
    license = licenses.bsd2;
    maintainers = with maintainers; [ emily ];
  };
}

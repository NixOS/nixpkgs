{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, setuptools
, setuptools_scm
, pyvcd
, jinja2
, importlib-resources
, importlib-metadata

# for tests
, pytestCheckHook
, yosys
, symbiyosys
, yices
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

  nativeBuildInputs = [ setuptools_scm ];

  propagatedBuildInputs = [
    setuptools
    pyvcd
    jinja2
  ] ++
    lib.optional (pythonOlder "3.9") importlib-resources ++
    lib.optional (pythonOlder "3.8") importlib-metadata;

  checkInputs = [ pytestCheckHook yosys symbiyosys yices ];

  preBuild = ''
    export SETUPTOOLS_SCM_PRETEND_VERSION="${realVersion}"
  '';

  meta = with lib; {
    description = "A refreshed Python toolbox for building complex digital hardware";
    homepage = "https://nmigen.info/nmigen";
    license = licenses.bsd2;
    maintainers = with maintainers; [ emily ];
  };
}

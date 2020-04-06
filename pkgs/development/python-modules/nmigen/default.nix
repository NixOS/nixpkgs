{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, setuptools
, setuptools_scm
, pyvcd
, jinja2

# for tests
, yosys
, symbiyosys
, yices
}:

buildPythonPackage rec {
  pname = "nmigen";
  version = "unstable-2019-02-08";
  # python setup.py --version
  realVersion = "0.2.dev49+g${lib.substring 0 7 src.rev}";

  src = fetchFromGitHub {
    owner = "nmigen";
    repo = "nmigen";
    rev = "66f4510c4465be5d0763d7835770553434e4ee91";
    sha256 = "19y39c4ywckm4yzrpjzcdl9pqy9d1sf1zsb4zpzajpmnfqccc3b0";
  };

  disabled = pythonOlder "3.6";

  nativeBuildInputs = [ setuptools_scm ];

  propagatedBuildInputs = [ setuptools pyvcd jinja2 ];

  checkInputs = [ yosys symbiyosys yices ];

  preBuild = ''
    export SETUPTOOLS_SCM_PRETEND_VERSION="${realVersion}"
  '';

  meta = with lib; {
    description = "A refreshed Python toolbox for building complex digital hardware";
    homepage = https://github.com/nmigen/nmigen;
    license = licenses.bsd2;
    maintainers = with maintainers; [ emily ];
  };
}

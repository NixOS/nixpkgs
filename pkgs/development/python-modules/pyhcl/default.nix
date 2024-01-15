{ buildPythonPackage
, fetchFromGitHub
, isPy3k
, lib

# pythonPackages
, coverage
, pytest
}:

buildPythonPackage rec {
  pname = "pyhcl";
  version = "0.4.4";
  format = "setuptools";
  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "virtuald";
    repo = pname;
    rev = version;
    sha256 = "0rcpx4vvj2c6wxp31vay7a2xa5p62kabi91vps9plj6710yz29nc";
  };

  # https://github.com/virtuald/pyhcl/blob/51a7524b68fe21e175e157b8af931016d7a357ad/setup.py#L64
  configurePhase = ''
    echo '__version__ = "${version}"' > ./src/hcl/version.py
  '';

  nativeCheckInputs = [
    coverage
    pytest
  ];

  # https://github.com/virtuald/pyhcl/blob/51a7524b68fe21e175e157b8af931016d7a357ad/tests/run_tests.sh#L4
  checkPhase = ''
    coverage run --source hcl -m pytest tests
  '';

  meta = with lib; {
    description = "HCL is a configuration language. pyhcl is a python parser for it";
    homepage = "https://github.com/virtuald/pyhcl";
    license = licenses.mpl20;
    maintainers = with maintainers; [
      kamadorueda
    ];
  };
}

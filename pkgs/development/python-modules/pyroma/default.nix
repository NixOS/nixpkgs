{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, docutils
, python
, pythonOlder
, pygments
, setuptools
, requests
}:

buildPythonPackage rec {
  pname = "pyroma";
  version = "3.2";

  src = fetchFromGitHub {
    owner = "regebro";
    repo = pname;
    rev = version;
    sha256 = "0ln9w984n48nyxwzd1y48l6b18lnv52radcyizaw56lapcgxrzdr";
  };

  patches = lib.optionals (pythonOlder "3.8") [
    # upstream fix for python-3.7 test failures:
    #  https://github.com/NixOS/nixpkgs/issues/136901
    (fetchpatch {
      name = "fix-py37-tests.patch";
      url = "https://github.com/regebro/pyroma/commit/d30bc41da7d17a0737eb8ad2267457eff4cac82c.patch";
      sha256 = "003vvp360cc05kas6bm6pdd6wgw4x3399sprr6pl7f654s730psq";
      excludes = [ "HISTORY.txt" ];
    })
  ];

  propagatedBuildInputs = [
    docutils
    pygments
    setuptools
    requests
  ];

  # https://github.com/regebro/pyroma/blob/3.2/Makefile#L23
  # PyPITest requires network access
  checkPhase = ''
    ${python.interpreter} -m unittest -k 'not PyPITest' pyroma.tests
  '';

  pythonImportsCheck = [ "pyroma" ];

  meta = with lib; {
    description = "Test your project's packaging friendliness";
    homepage = "https://github.com/regebro/pyroma";
    license = licenses.mit;
    maintainers = with maintainers; [ kamadorueda ];
  };
}

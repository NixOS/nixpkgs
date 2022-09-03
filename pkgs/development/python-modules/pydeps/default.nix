{ lib
, buildPythonPackage
, fetchFromGitHub
, graphviz
, stdlib-list
, pytestCheckHook
, pythonOlder
, pyyaml
}:

buildPythonPackage rec {
  pname = "pydeps";
  version = "1.10.22";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "thebjorn";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-PA+TpPAuzyAQSlD08ZgmZAKgVEGoIUw/zq4QdTmU8HE=";
  };

  buildInputs = [
    graphviz
  ];

  propagatedBuildInputs = [
    graphviz
    stdlib-list
  ];

  checkInputs = [
    pytestCheckHook
    pyyaml
  ];

  postPatch = ''
    # Path is hard-coded
    substituteInPlace pydeps/dot.py \
      --replace "dot -Gstart=1" "${lib.makeBinPath [ graphviz ]}/dot -Gstart=1"
  '';

  disabledTests = [
    # Would require to have additional modules available
    "test_find_package_names"
  ];

  pythonImportsCheck = [
    "pydeps"
  ];

  meta = with lib; {
    description = "Python module dependency visualization";
    homepage = "https://github.com/thebjorn/pydeps";
    license = licenses.bsd2;
    maintainers = with maintainers; [ fab ];
  };
}

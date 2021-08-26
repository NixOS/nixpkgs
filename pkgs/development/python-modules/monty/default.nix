{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, msgpack
, pytestCheckHook
, numpy
, pydantic
, pymongo
, ruamel_yaml
, tqdm
}:

buildPythonPackage rec {
  pname = "monty";
  version = "2021.6.10";
  disabled = pythonOlder "3.5"; # uses type annotations

  # No tests in Pypi
  src = fetchFromGitHub {
    owner = "materialsvirtuallab";
    repo = pname;
    rev = "v${version}";
    sha256 = "01fhl4pl5gj4ahph4lxcm0fmglh0bjw6jz9ckmgzviasg4l1j6h4";
  };

  propagatedBuildInputs = [
    ruamel_yaml
    tqdm
    msgpack
  ];

  checkInputs = [
    pytestCheckHook
    numpy
    pydantic
    pymongo
  ];

  preCheck = ''
    substituteInPlace tests/test_os.py \
      --replace 'self.assertEqual("/usr/bin/find", which("/usr/bin/find"))' '#'
  '';

  meta = with lib; {
    description = "Serves as a complement to the Python standard library by providing a suite of tools to solve many common problems";
    longDescription = "
      Monty implements supplementary useful functions for Python that are not part of the
      standard library. Examples include useful utilities like transparent support for zipped files, useful design
      patterns such as singleton and cached_class, and many more.
    ";
    homepage = "https://github.com/materialsvirtuallab/monty";
    license = licenses.mit;
    maintainers = with maintainers; [ psyanticy ];
  };
}

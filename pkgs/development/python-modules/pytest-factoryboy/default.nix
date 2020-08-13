{ stdenv
, fetchFromGitHub
, buildPythonPackage
, pytestCheckHook
, pytest
, inflection
, factory_boy
, pytestcache
, pytestcov
, pytestpep8
, mock
}:

buildPythonPackage rec {
  pname = "pytest-factoryboy";
  version = "2.0.3";

  src = fetchFromGitHub {
    owner = "pytest-dev";
    repo = "pytest-factoryboy";
    rev = version;
    sha256 = "0m1snyybq2k51khlydhisq300vzys897vdbsicph628iran950hn";
  };

  propagatedBuildInputs = [ factory_boy inflection pytest ];

  # The project uses tox, which we can't. So we simply run pytest manually.
  checkInputs = [
    mock
    pytestCheckHook
    pytestcache
    pytestcov
    pytestpep8
  ];
  pytestFlagsArray = [ "--ignore=docs" ];

  meta = with stdenv.lib; {
    description = "Integration of factory_boy into the pytest runner.";
    homepage = "https://pytest-factoryboy.readthedocs.io/en/latest/";
    maintainers = with maintainers; [ winpat ];
    license = licenses.mit;
  };
}

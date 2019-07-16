{ lib
, buildPythonPackage
, fetchPypi
, hopcroftkarp
, multiset
, pytest_3
, pytestrunner
, hypothesis
, setuptools_scm
, isPy27
}:

buildPythonPackage rec {
  pname = "matchpy";
  version = "0.5.1";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1vvf1cd9kw5z1mzvypc9f030nd18lgvvjc8j56b1s9b7dyslli2r";
  };

  postPatch = ''
    substituteInPlace setup.cfg --replace "hypothesis>=3.6,<4.0" "hypothesis"
  '';

  buildInputs = [ setuptools_scm pytestrunner ];
  checkInputs = [ pytest_3 hypothesis ];
  propagatedBuildInputs = [ hopcroftkarp multiset ];

  meta = with lib; {
    description = "A library for pattern matching on symbolic expressions";
    homepage = https://github.com/HPAC/matchpy;
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}

{ lib
, stdenv
, buildPythonPackage
, fastnumbers
, fetchFromGitHub
, hypothesis
, pytestCheckHook
, pythonOlder
, typing-extensions
}:

buildPythonPackage rec {
  pname = "fastnumbers";
  version = "3.2.1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "SethMMorton";
    repo = pname;
    rev = version;
    sha256 = "1v9l5p90y6ygrs0qmgdzxfv2vp1mpfp65snkl9jp6kcy44g3alhp";
  };

  propagatedBuildInputs = [
    typing-extensions
  ];

  # Tests fail due to numeric precision differences on ARM
  # See https://github.com/SethMMorton/fastnumbers/issues/28
  doCheck = !stdenv.hostPlatform.isAarch;

  checkInputs = [
    hypothesis
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "fastnumbers"
  ];

  meta = with lib; {
    description = "Python module for number conversion";
    homepage = "https://github.com/SethMMorton/fastnumbers";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}

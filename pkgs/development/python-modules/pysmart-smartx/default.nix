{ lib
, buildPythonPackage
, fetchFromGitHub
, isPy3k
, future
, pytestCheckHook
, mock
}:

buildPythonPackage rec {
  pname = "pysmart-smartx";
  version = "0.3.10";

  src = fetchFromGitHub {
    owner = "smartxworks";
    repo = "pySMART";
    rev = "v${version}";
    sha256 = "1irl4nlgz3ds3aikraa9928gzn6hz8chfh7jnpmq2q7d2vqbdrjs";
  };

  propagatedBuildInputs = [ future ];

  # tests require contextlib.nested
  doCheck = !isPy3k;

  checkInputs = [ pytestCheckHook mock ];

  pythonImportsCheck = [ "pySMART" ];

  meta = with lib; {
    description = "It's a fork of pySMART with lots of bug fix and enhances";
    homepage = "https://github.com/smartxworks/pySMART";
    maintainers = with maintainers; [ rhoriguchi ];
    license = licenses.gpl2Only;
  };
}

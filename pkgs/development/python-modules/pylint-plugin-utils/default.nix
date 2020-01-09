{ buildPythonPackage
, fetchFromGitHub
, isPy3k
, lib

# pythonPackages
, pylint
}:

buildPythonPackage rec {
  pname = "pylint-plugin-utils";
  version = "0.6";
  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "PyCQA";
    repo = pname;
    rev = version;
    sha256 = "1zapmbczxs1phrwbd0yvpfxhljd2pyv4pi9rwggaq38lcnc325s7";
  };

  propagatedBuildInputs = [
    pylint
  ];

  checkPhase = ''
    python tests.py
  '';

  meta = with lib; {
    description = "Utilities and helpers for writing Pylint plugins";
    homepage = "https://github.com/PyCQA/pylint-plugin-utils";
    license = licenses.gpl2;
    maintainers = with maintainers; [
      kamadorueda
    ];
  };
}
